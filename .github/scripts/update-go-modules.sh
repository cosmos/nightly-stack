#!/bin/bash

set -oue pipefail

## FUNCTIONS

# Function to get the latest commit SHA for a given repo and branch
get_latest_commit() {
    local repo=$1
    local branch=$2
    output=$(git ls-remote "https://github.com/${repo}.git" "${branch}" | cut -f1)

    if [ -z "$output" ]; then
        echo "Error: Failed to retrieve commit hash from ${repo}/${branch}" >&2
        exit 1
    else
        echo "$output"
    fi
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

    if [ $? -ne 0 ]; then
        echo "Error occurred while getting pseudo-version for $module@$commit" >&2
        exit 1
    fi

    echo "Updating $module to pseudo-version $pseudo_version"

    go mod edit -replace=$module=$module@$pseudo_version

    return 0
}

# Function to check if current module is replaced by a local path
check_replaced_local() {
    go mod edit --json | jq -e --arg v "$module" '
        (.Replace[] | select(.Old.Path | contains($v))) as $replacement
        | if $replacement.New.Path | contains("../") then
            0
            else
            error("No ../ found in the New.Path")
        end
        ' > /dev/null 2>&1

    if [ $? -ne 0 ]; then
        return 1
    else
        return 0
    fi
}

## VARIABLES

# github.com/cosmos/cosmos-sdk branch to follow
COSMOSSDK_BRANCH=${COSMOSSDK_BRANCH}
# github.com/cometbft/cometbft branch to follow
COMETBFT_BRANCH=${COMETBFT_BRANCH:-main}

## INTERNAL VARIABLES

### Commits
cosmossdk_latest_commit_main=$(get_latest_commit "cosmos/cosmos-sdk" "main")
echo "cosmos/cosmos-sdk main latest_commit: $cosmossdk_latest_commit_main"
cosmossdk_latest_commit_branch=$(get_latest_commit "cosmos/cosmos-sdk" "$COSMOSSDK_BRANCH")
echo "cosmos/cosmos-sdk $COSMOSSDK_BRANCH latest_commit: $cosmossdk_latest_commit_branch"
cometbft_latest_commit_branch=$(get_latest_commit "cometbft/cometbft" "$COMETBFT_BRANCH")
echo "cometbft/cometbft $COMETBFT_BRANCH latest_commit: $cometbft_latest_commit_branch"

### go.mod : Extract module paths and versions from current folder
modules=$(go mod edit --json | jq -r '.Require[] | select(.Path | contains("/")) | .Path')

# Parse every module in go.mod, and update dependencies according to logic
for module in $modules; do

    echo "module: $module"

    # Checking if module is not already replaced with local path
    if ! check_replaced_local; then

        # Checking cosmos-sdk modules
        case "$module" in
            *cosmossdk.io*)
                case "$module" in
                    # Force checking specific modules to HEAD of main instead of release
                    *core/testing*|*depinject*|*log*|*math*|*schema*)
                        if ! get_and_update_module "$cosmossdk_latest_commit_main"; then
                            echo "Failed to update module $module after trying main."
                            exit 1
                        fi
                        ;;
                    *errors*|*api*|*core*)
                        echo "ignore $module"
                        ;;
                    *)
                            if ! get_and_update_module "$cosmossdk_latest_commit_branch"; then
                                echo "Failed to update module $module after trying $COSMOSSDK_BRANCH."
                            fi
                        ;;
                esac
                ;;
            *github.com/cosmos/cosmos-sdk*)

                # modules that need to follow HEAD on release branch
                if ! get_and_update_module "$cosmossdk_latest_commit_branch"; then
                    echo "Failed to update module $module after trying $COSMOSSDK_BRANCH."
                    exit 1
                fi
                ;;
            *github.com/cometbft/cometbft*)
                # Do not execute on cosmos-sdk release branches
                if [[ "$COSMOSSDK_BRANCH" == "main" ]]; then
                    # Exclude cometbft/cometbft-db from logic
                    if [[ ! "$module" =~ "cometbft-db" ]]; then
                        if ! get_and_update_module "$cometbft_latest_commit_branch"; then
                            echo "Failed to update module $module after trying main."
                            exit 1
                        fi
                    fi
                fi
        esac
    else
        echo "module $module is already replaced by local path"
    fi
done

go mod verify
go mod tidy
