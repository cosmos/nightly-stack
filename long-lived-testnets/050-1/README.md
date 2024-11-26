# Chain Details: `050-1`

## Basic Information

- **Chain-ID:** `050-1`
- **Denom:** `stake`
- **Application:** [Simapp - Cosmos-SDK v0.50.x](https://github.com/cosmos/cosmos-sdk/tree/release/v0.50.x/simapp)
- **Binary:** [Download Latest Build](https://github.com/cosmos/nightly-stack/actions/workflows/nightlies-scheduled.yaml)
  - Filename: `cosmos-sdk-v0.50.x-mods-<os>-<arch>`
- **Genesis File:** `genesis.json`
  - SHA256: `0030178d3d443a1b539b0a6d8546af2b0c1c86e5c368702c3f15ebba56f6c946`
- **Launch Date:** 2024-11-26

## Network Endpoints

| Service | Endpoint                                                                            |
| ------- | ----------------------------------------------------------------------------------- |
| API     | `https://050-1-testnet-api.interchainsdk.io:443`                                    |
| gRPC    | `050-1-testnet-grpc.interchainsdk.io:443`                                           |
| RPC     | `https://050-1-testnet-rpc.interchainsdk.io:443`                                    |
| Seed    | `2b3a9c592eea86a4198b1de6e1eac15d42de32f7@050-1-testnet-p2p.interchainsdk.io:20056` |

## Join the Network

To join the network, execute the following commands:

```bash
# Initialize the node
./cosmos-sdk-v0.50.x-mods-<os>-<arch> init <moniker> --chain-id 050-1

# Download genesis file
wget --quiet --output-document ~/.simapp/config/genesis.json https://raw.githubusercontent.com/cosmos/nightly-stack/refs/heads/main/long-lived-testnets/050-1/genesis.json

# Start the node
./cosmos-sdk-v0.50.x-mods-<os>-<arch> start

> Note: Replace <os>, <arch>, and <moniker> with your operating system, architecture, and desired node name respectively.
```

## Utilities

| Service        | URL                                          |
| -------------- | -------------------------------------------- |
| Block Explorer | `https://explorer-testnet.interchainsdk.io/` |
| Faucet         | `https://faucet-testnet.interchainsdk.io/`   |
