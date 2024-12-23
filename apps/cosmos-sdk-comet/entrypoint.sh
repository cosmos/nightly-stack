#!/usr/bin/env bash

set -Eeuo pipefail
set -x

export HOME="${NODE_HOME:-/config}"
COSMOS_CHAIN_ID="${COSMOS_CHAIN_ID:-testchain}"
COSMOS_MONIKER="${COSMOS_MONIKER:-testchain-node}"
COSMOS_NODE_CMD=/app/node
GENESIS_ENABLED="${GENESIS_ENABLED:-true}"
GENESIS_FILE="${HOME}/config/genesis.json"

if [[ ! -f "${HOME}/config/config.toml" ]]; then
    echo "Launch init procedure..."

    # Configure client settings
    "${COSMOS_NODE_CMD}" config set client chain-id "${COSMOS_CHAIN_ID}" --home "${HOME}"
    "${COSMOS_NODE_CMD}" config set client keyring-backend test --home "${HOME}"
    "${COSMOS_NODE_CMD}" config set app api.enable true --home "${HOME}"

    # Add keys
    for user in validator faucet alice bob; do
        "${COSMOS_NODE_CMD}" keys add "${user}" --home "${HOME}"
    done

    # Initialize node
    "${COSMOS_NODE_CMD}" init "${COSMOS_MONIKER}" --chain-id "${COSMOS_CHAIN_ID}" --home "${HOME}"

    # Generate a new chain
    if [[ "${GENESIS_ENABLED}" == "true" ]]; then

        # Set governance and inflation parameters
        jq '.app_state.gov.params.voting_period = "20s" |
            .app_state.gov.params.expedited_voting_period = "300s" |
            .app_state.mint.minter.inflation = "0.300000000000000000"' \
            "${GENESIS_FILE}" >temp.json && mv temp.json "${GENESIS_FILE}"

        # Add genesis accounts
        for account in validator faucet alice bob; do
            "${COSMOS_NODE_CMD}" genesis add-genesis-account "${account}" 5000000000000stake --keyring-backend test --home "${HOME}"
        done
        "${COSMOS_NODE_CMD}" genesis gentx validator 1000000000stake --chain-id "${COSMOS_CHAIN_ID}" --home "${HOME}"
        "${COSMOS_NODE_CMD}" genesis collect-gentxs --home "${HOME}"
    fi
fi

exec \
    "${COSMOS_NODE_CMD}" start --home "${HOME}" \
    "$@"
