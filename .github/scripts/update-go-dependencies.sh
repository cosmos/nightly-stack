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

    if ! go mod download $module@$pseudo_version; then
        echo "Download failed. Trying with a different commit."
        return 1
    fi

    return 0
}

# Extract module paths and versions from go.mod on current folder
modules=$(go mod edit --json | jq -r '.Require[] | select(.Path | contains("/")) | .Path')

latest_commit_main=$(get_latest_commit "cosmos/cosmos-sdk" "main")
echo "cosmos/cosmos-sdk main latest_commit: $latest_commit_main"
latest_commit_branch=$(get_latest_commit "cosmos/cosmos-sdk" "$COSMOSSDK_BRANCH")
echo "cosmos/cosmos-sdk $COSMOSSDK_BRANCH latest_commit: $latest_commit_branch"

# Version override logic
for module in $modules; do

    echo "module: $module"

    if [[ $module =~ "cosmossdk.io" ]]; then
        if ! get_and_update_module "$latest_commit_branch"; then
            # If it fails, get the from main
            if ! get_and_update_module "$latest_commit_main"; then
                echo "Failed to update module after trying $COSMOSSDK_BRANCH and main."
                exit 1
            fi
        fi
    elif [[ $module == "github.com/cosmos/cosmos-sdk" ]]; then
        # modules that need to follow HEAD on release branch
        pseudo_version=$(get_pseudo_version "github.com/cosmos/cosmos-sdk" $latest_commit_branch)
        echo "Updating $module to pseudo-version $pseudo_version"
        go mod edit -replace=$module=$module@$pseudo_version
        go mod download $module@$pseudo_version
    fi
done

go mod verify
go mod tidy
