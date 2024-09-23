#!/bin/bash

set -oue pipefail

COSMOSSDK_BRANCH=${COSMOSSDK_BRANCH:-refs/heads/release/v0.50.x}

# Function to get the latest commit SHA for a given repo and branch
get_latest_commit() {
    local repo=$1
    local branch=$2
    git ls-remote "https://github.com/${repo}.git" "${branch}" | cut -f1
}

# Function to get pseudo-version from commit SHA
get_pseudo_version() {
    local repo=$1
    local commit_sha=$2

    pseudo_version=$(go list -m -f '{{.Version}}' $repo@$commit_sha 2>/dev/null)

    if [ -z "$pseudo_version" ]; then
        echo "Error: Unable to find pseudo-version for $repo@$commit_sha"
        return 1
    else
        echo "${pseudo_version}"
    fi
}

get_and_update_module() {
    local commit=$1
    pseudo_version=$(get_pseudo_version "$module" "$commit")

    echo "Updating $module to pseudo-version $pseudo_version"

    go mod edit -replace=$module=$module@$pseudo_version

    # if ! go mod download $module@$pseudo_version; then
    #     return 1
    # fi

    return 0
}

# Extract module paths and versions from go.mod on current folder
modules=$(go mod edit --json | jq -r '.Require[] | select(.Path | contains("/")) | .Path')

latest_commit_main=$(get_latest_commit "cosmos/cosmos-sdk" "main")
echo "cosmos/cosmos-sdk main latest_commit: $latest_commit_main"
latest_commit_branch=$(get_latest_commit "cosmos/cosmos-sdk" "$COSMOSSDK_BRANCH")
echo "cosmos/cosmos-sdk $COSMOSSDK_BRANCH latest_commit: $latest_commit_branch"

# Parse every module in go.mod, and update dependencies according to logic
for module in $modules; do

    echo "module: $module"

    # Checking cosmos-sdk modules
    if [[ $module =~ "cosmossdk.io" ]]; then
        # Force specific modules to HEAD of main instead of release
        if [[ $module =~ "depinject" ]] || [[ $module =~ "log" ]] || [[ $module =~ "math" ]]; then
            if ! get_and_update_module "$latest_commit_main"; then
                echo "Failed to update module $module after trying main."
                exit 1
            fi
        else
            if ! get_and_update_module "$latest_commit_branch"; then
                echo "Failed to update module $module after trying $COSMOSSDK_BRANCH."
            fi
        fi
    elif [[ $module == "github.com/cosmos/cosmos-sdk" ]]; then
        # modules that need to follow HEAD on release branch
        if ! get_and_update_module "$latest_commit_branch"; then
            echo "Failed to update module $module after trying $COSMOSSDK_BRANCH."
            exit 1
        fi
    fi
done

go mod verify
go mod tidy
