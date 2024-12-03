#!/usr/bin/env bash

set -oue pipefail
set -x

BINARY_PATH="${BINARY_BUILD_OUTPUT_PATH}"

# Set the timeout to 60 seconds
TIMEOUT=60
START_TIME=$(date +%s)

echo "Launch init procedure..."
CONFIG_HOME=$(${BINARY_PATH} config home)
${BINARY_PATH} config set client chain-id testchain
${BINARY_PATH} config set client keyring-backend test
sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.002token1"/' "${CONFIG_HOME}/config/app.toml"
${BINARY_PATH} config set app api.enable true
${BINARY_PATH} keys add alice
${BINARY_PATH} keys add bob
${BINARY_PATH} init testchain-node --chain-id testchain
jq '.app_state.gov.params.voting_period = "600s"' "${CONFIG_HOME}/config/genesis.json" > temp.json && mv temp.json "${CONFIG_HOME}/config/genesis.json"
jq '.app_state.gov.params.expedited_voting_period = "300s"' "${CONFIG_HOME}/config/genesis.json" > temp.json && mv temp.json "${CONFIG_HOME}/config/genesis.json"
jq '.app_state.mint.minter.inflation = "0.300000000000000000"' "${CONFIG_HOME}/config/genesis.json" > temp.json && mv temp.json "${CONFIG_HOME}/config/genesis.json" # to change the inflation
${BINARY_PATH} genesis add-genesis-account alice 5000000000stake --keyring-backend test
${BINARY_PATH} genesis add-genesis-account bob 5000000000stake --keyring-backend test
${BINARY_PATH} genesis gentx alice 1000000stake --chain-id testchain
${BINARY_PATH} genesis collect-gentxs

# trunk-ignore(shellcheck/SC2210)
${BINARY_PATH} start > ./output.log 2>1 &
APP_PID=$!


while true; do
  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

  if [[ "${ELAPSED_TIME}" -ge "${TIMEOUT}" ]]; then
    echo "Timeout reached. Application did not produce the success pattern within 60 seconds."
    kill "${APP_PID}"
    cat ./output.log
    exit 1
  fi

  # Check that 4th block is produced to validate the application
  if ${BINARY_PATH} query block-results 4; then
    echo "Block #4 has been committed. Application is working correctly."
    kill "${APP_PID}"
    exit 0
  else
    echo "Block height is not greater than 4."
  fi

  sleep 3
done
