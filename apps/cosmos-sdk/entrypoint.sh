#!/usr/bin/env bash

set -euo pipefail
set -x

export HOME="${NODE_HOME:-/config}"
export SHARED_VOLUME="${SHARED_VOLUME:-/mnt/shared-volume}"
COSMOS_CHAIN_ID="${COSMOS_CHAIN_ID:-testchain}"
COSMOS_MONIKER="${COSMOS_MONIKER:-testchain-node}"
COSMOS_NODE_CMD=/app/node
GENESIS_ENABLED="${GENESIS_ENABLED:-true}"
GENESIS_VALIDATORS_NUMBER="${GENESIS_VALIDATORS_NUMBER:-1}"
GENESIS_FILE="${HOME}/config/genesis.json"

TIMEOUT=600  # Timeout in seconds
START_TIME=$(date +%s)

if [[ ! -f "${HOME}/config/config.toml" ]]; then
    echo "Launch init procedure..."

    # Configure client settings
    "${COSMOS_NODE_CMD}" config set client chain-id "${COSMOS_CHAIN_ID}" --home "${HOME}"
    "${COSMOS_NODE_CMD}" config set client keyring-backend test --home "${HOME}"
    "${COSMOS_NODE_CMD}" config set app api.enable true --home "${HOME}"

    # Initialize node
    "${COSMOS_NODE_CMD}" init "${COSMOS_MONIKER}" --chain-id "${COSMOS_CHAIN_ID}" --home "${HOME}"

    # Get validator position
    if [ "$GENESIS_VALIDATORS_NUMBER" -gt 1 ]; then
        VALIDATOR_POSITION="${COSMOS_MONIKER: -1}"
        if [[ "${VALIDATOR_POSITION}" =~ ^[0-9]$ ]]; then
            export validator="validator-${VALIDATOR_POSITION}"
        else
            echo "Last character on moniker '$COSMOS_MONIKER' is not a number"
            exit 1
        fi
    fi

    # Add validator keys
    validator="${validator:-validator}"
    if [ "$GENESIS_VALIDATORS_NUMBER" -gt 1 ]; then
        # export keys on shared volume
        "${COSMOS_NODE_CMD}" keys add "${validator}" --home "${HOME}" 2>&1 1>/dev/null | tail -n 1 > "${SHARED_VOLUME}/${validator}.mnemonic"
    else
        "${COSMOS_NODE_CMD}" keys add "${validator}" --home "${HOME}"
    fi
    # Generate a new chain
    if [[ "${GENESIS_ENABLED}" == "true" ]]; then
        echo "Launch genesis procedure..."

        # Set governance and inflation parameters
        jq '.app_state.gov.params.voting_period = "20s" |
            .app_state.gov.params.expedited_voting_period = "10s" |
            .app_state.mint.minter.inflation = "0.300000000000000000"' \
            "${GENESIS_FILE}" >temp.json && mv temp.json "${GENESIS_FILE}"

        # Add faucet keys
        "${COSMOS_NODE_CMD}" keys add faucet --home "${HOME}"
        "${COSMOS_NODE_CMD}" genesis add-genesis-account faucet 5000000000000stake --keyring-backend test --home "${HOME}"

        # validator add-genesis-account
        if [ "$GENESIS_VALIDATORS_NUMBER" -gt 1 ]; then
            # add genesis-accounts for every validator
            for ((i=1; i<=$GENESIS_VALIDATORS_NUMBER; i++)); do
                if [ "${validator}" != "validator-${i}" ]; then
                    MNEMONIC_FILE="${SHARED_VOLUME}/validator-${i}.mnemonic"
                    FOUND=false

                    while [ "$FOUND" = false ]; do
                        CURRENT_TIME=$(date +%s)
                        ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

                        # Check if timeout reached
                        if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
                            echo "Timeout reached after $TIMEOUT seconds waiting for ${MNEMONIC_FILE}"
                            exit 1
                        fi

                        if [ -f "$MNEMONIC_FILE" ]; then
                            echo "Found key file: ${MNEMONIC_FILE}"
                            echo $(cat "${MNEMONIC_FILE}") | "${COSMOS_NODE_CMD}" keys add "validator-${i}" --recover --home "${HOME}" || true
                            FOUND=true
                        else
                            echo "Waiting for ${MNEMONIC_FILE}: $(date '+%H:%M:%S') (${ELAPSED_TIME}s elapsed)"
                            sleep 3
                        fi
                    done
                fi
                "${COSMOS_NODE_CMD}" genesis add-genesis-account "validator-${i}" 5000000000000stake --keyring-backend test --home "${HOME}"
            done
        else
            # Single validator mode
            "${COSMOS_NODE_CMD}" genesis add-genesis-account "${validator}" 5000000000000stake --keyring-backend test --home "${HOME}"
        fi

        # stake into the chain
        "${COSMOS_NODE_CMD}" genesis gentx "${validator}" 400000000000stake --chain-id "${COSMOS_CHAIN_ID}" --home "${HOME}"
        "${COSMOS_NODE_CMD}" genesis collect-gentxs --home "${HOME}"
        "${COSMOS_NODE_CMD}" genesis validate --home "${HOME}"
    fi
fi

exec \
    "${COSMOS_NODE_CMD}" start --home "${HOME}" \
    "$@"
