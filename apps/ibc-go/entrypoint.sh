#!/usr/bin/env bash

set -Eeuo pipefail
set -x

NODE_HOME=${NODE_HOME:-/config}
START_CMD=${START_CMD:-start}

if [[ ! -f "${NODE_HOME}/config.json" ]]; then
    echo "Launch init procedure..."
    /app/node config set client chain-id testchain --home ${NODE_HOME}
    /app/node config set client keyring-backend test --home ${NODE_HOME}
    /app/node config set client keyring-default-keyname alice --home ${NODE_HOME}
    /app/node config set app api.enable true --home ${NODE_HOME}
    /app/node keys add alice --home ${NODE_HOME}
    /app/node keys add bob --home ${NODE_HOME}
    /app/node init testchain-node --chain-id testchain --home ${NODE_HOME}
    jq '.app_state.gov.params.voting_period = "600s"' ${NODE_HOME}/config/genesis.json > temp.json && mv temp.json ${NODE_HOME}/config/genesis.json
    jq '.app_state.gov.params.expedited_voting_period = "300s"' ${NODE_HOME}/config/genesis.json > temp.json && mv temp.json ${NODE_HOME}/config/genesis.json
    jq '.app_state.mint.minter.inflation = "0.300000000000000000"' ${NODE_HOME}/config/genesis.json > temp.json && mv temp.json ${NODE_HOME}/config/genesis.json # to change the inflation
    /app/node genesis add-genesis-account alice 5000000000stake --keyring-backend test --home ${NODE_HOME}
    /app/node genesis add-genesis-account bob 5000000000stake --keyring-backend test --home ${NODE_HOME}
    /app/node genesis gentx alice 1000000stake --chain-id testchain --home ${NODE_HOME}
    /app/node genesis collect-gentxs --home ${NODE_HOME}
fi

exec \
    /app/node ${START_CMD} --home ${NODE_HOME} \
    "$@"