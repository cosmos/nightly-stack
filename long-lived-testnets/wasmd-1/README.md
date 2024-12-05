# Chain Details: `wasmd-1`

## Basic Information

- **Chain-ID:** `wasmd-1`
- **Denom:** `stake`
- **Application:** [Wasmd - CosmWasm + Cosmos-SDK v0.52.x](https://github.com/CosmWasm/wasmd)
- **Binary:** [Download Latest Build](https://github.com/cosmos/nightly-stack/actions/workflows/nightlies-scheduled.yaml)
  - Filename: `wasmd-v0.52.x-<os>-<arch>`
- **Genesis File:** `genesis.json`
  - SHA256: `7deff113b8fc6ef743092f3819c248cb8d186ca0b40f7220b2533b3498b26d84`
- **Launch Date:** 2024-12-05

## Network Endpoints

| Service | Endpoint                                                                            |
| ------- | ----------------------------------------------------------------------------------- |
| API     | `https://wasmd-1-testnet-api.interchainsdk.io:443`                                    |
| gRPC    | `wasmd-1-testnet-grpc.interchainsdk.io:443`                                           |
| RPC     | `https://wasmd-1-testnet-rpc.interchainsdk.io:443`                                    |
| Seed    | `c1946bc2c95b23c6e09a6bbc0e2d9807d81646b1@wasmd-1-testnet-p2p.interchainsdk.io:20356` |

## Join the Network

To join the network, execute the following commands:

```bash
# Initialize the node
./wasmd-v0.52.x-<os>-<arch> init <moniker> --chain-id wasmd-1

# Download genesis file
wget --quiet --output-document ~/.simapp/config/genesis.json https://raw.githubusercontent.com/cosmos/nightly-stack/refs/heads/main/long-lived-testnets/wasmd-1/genesis.json

# Start the node
./wasmd-v0.52.x-<os>-<arch> start

> Note: Replace <os>, <arch>, and <moniker> with your operating system, architecture, and desired node name respectively.
```

## Utilities

| Service        | URL                                          |
| -------------- | -------------------------------------------- |
| Block Explorer | `https://explorer-testnet.interchainsdk.io/` |
| Faucet         | `https://faucet-testnet.interchainsdk.io/`   |
