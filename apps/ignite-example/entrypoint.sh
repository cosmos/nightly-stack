#!/usr/bin/env bash

set -Eeuo pipefail
set -x

export HOME="${NODE_HOME:-/config}"
COSMOS_CHAIN_ID="${COSMOS_CHAIN_ID:-testchain}"
COSMOS_MONIKER="${COSMOS_MONIKER:-testchain-node}"
COSMOS_NODE_CMD=/app/node
GENESIS_FILE="${HOME}/config/genesis.json"

if [[ ! -f "${HOME}/config/config.toml" ]]; then
    echo "Launch init procedure..."

    # Configure client settings
    /app/node config set client chain-id "${COSMOS_CHAIN_ID}" --home "${HOME}"
    /app/node config set client keyring-backend test  --home "${HOME}"
    sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.002token1"/' "${HOME}/config/app.toml"
    /app/node config set app api.enable true --home "${HOME}"

    # Add keys
    for user in validator faucet alice bob; do
        "${COSMOS_NODE_CMD}" keys add "${user}" --home "${HOME}"
    done

    # Save mnemonics for specific users
    for user in validator faucet; do
        "${COSMOS_NODE_CMD}" keys mnemonic "${user}" --home "${HOME}">"${HOME}/${user}_mnemonic.txt"
    done

    # Initialize node
    "${COSMOS_NODE_CMD}" init "${COSMOS_MONIKER}" --chain-id "${COSMOS_CHAIN_ID}" --home "${HOME}"

    # Set governance and inflation parameters
    jq '.app_state.gov.params.voting_period = "600s" |
        .app_state.gov.params.expedited_voting_period = "300s" |
        .app_state.mint.minter.inflation = "0.300000000000000000"' \
        "${GENESIS_FILE}" >temp.json && mv temp.json "${GENESIS_FILE}"

    # Add genesis accounts
    for account in validator faucet alice bob; do
        "${COSMOS_NODE_CMD}" genesis add-genesis-account "${account}" 5000000000stake --keyring-backend test --home "${HOME}"
    done
    "${COSMOS_NODE_CMD}" genesis gentx validator 1000000stake --chain-id "${COSMOS_CHAIN_ID}" --home "${HOME}"
    "${COSMOS_NODE_CMD}" genesis collect-gentxs --home "${HOME}"
fi

exec \
    "${COSMOS_NODE_CMD}" start --home "${HOME}" \
    "$@"
