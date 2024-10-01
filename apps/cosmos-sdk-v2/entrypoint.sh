#!/usr/bin/env bash

set -Eeuo pipefail
set -x

COSMOS_CHAIN_ID=${COSMOS_CHAIN_ID:-testchain}
COSMOS_MONIKER=${COSMOS_MONIKER:-testchain-node}
COSMOS_NODE_HOME=${NODE_HOME:-/config}
COSMOS_START_CMD=${START_CMD:-start}

if [[ ! -f "${COSMOS_NODE_HOME}/config/config.toml" ]]; then
    echo "Launch init procedure..."
    /app/node config set client chain-id ${COSMOS_CHAIN_ID} --home ${COSMOS_NODE_HOME}
    /app/node config set client keyring-backend test --home ${COSMOS_NODE_HOME}
    /app/node keys add alice --indiscreet --home ${COSMOS_NODE_HOME}
    /app/node keys add bob --indiscreet --home ${COSMOS_NODE_HOME}
    /app/node init ${COSMOS_MONIKER} --chain-id ${COSMOS_CHAIN_ID} --home ${COSMOS_NODE_HOME}
    jq '.app_state.gov.params.voting_period = "600s"' ${COSMOS_NODE_HOME}/config/genesis.json > temp.json && mv temp.json ${COSMOS_NODE_HOME}/config/genesis.json
    jq '.app_state.gov.params.expedited_voting_period = "300s"' ${COSMOS_NODE_HOME}/config/genesis.json > temp.json && mv temp.json ${COSMOS_NODE_HOME}/config/genesis.json
    jq '.app_state.mint.minter.inflation = "0.300000000000000000"' ${COSMOS_NODE_HOME}/config/genesis.json > temp.json && mv temp.json ${COSMOS_NODE_HOME}/config/genesis.json # to change the inflation
    /app/node genesis add-genesis-account alice 5000000000stake --keyring-backend test --home ${COSMOS_NODE_HOME}
    /app/node genesis add-genesis-account bob 5000000000stake --keyring-backend test --home ${COSMOS_NODE_HOME}
    /app/node genesis gentx alice 1000000stake --chain-id ${COSMOS_CHAIN_ID} --home ${COSMOS_NODE_HOME}
    /app/node genesis collect-gentxs --home ${COSMOS_NODE_HOME}
fi

exec \
    /app/node ${COSMOS_START_CMD} --home ${COSMOS_NODE_HOME} \
    "$@"
