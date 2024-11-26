# Chain Details: `052-1`

## Basic Information

- **Chain-ID:** `052-1`
- **Denom:** `stake`
- **Application:** [Simapp - Cosmos-SDK v0.52.x](https://github.com/cosmos/cosmos-sdk/tree/release/v0.52.x/simapp)
- **Binary:** [Download Latest Build](https://github.com/cosmos/nightly-stack/actions/workflows/nightlies-scheduled.yaml)
  - Filename: `cosmos-sdk-v0.52.x-mods-<os>-<arch>`
- **Genesis File:** `genesis.json`
  - SHA256: `bbd1047cce76beca238247632fc7a2d7fdfa14dc34ad909ae061f9d7184d11c7`
- **Launch Date:** 2024-11-26

## Network Endpoints

| Service | Endpoint                                                                            |
| ------- | ----------------------------------------------------------------------------------- |
| API     | `https://052-1-testnet-api.interchainsdk.io:443`                                    |
| gRPC    | `052-1-testnet-grpc.interchainsdk.io:443`                                           |
| RPC     | `https://052-1-testnet-rpc.interchainsdk.io:443`                                    |
| Seed    | `c9b00dcf8f9646c768c7cfcce855e23e97a8f2bc@052-1-testnet-p2p.interchainsdk.io:20056` |

## Join the Network

To join the network, execute the following commands:

```bash
# Initialize the node
./cosmos-sdk-v0.52.x-mods-<os>-<arch> init <moniker> --chain-id 052-1

# Download genesis file
wget --quiet --output-document ~/.simapp/config/genesis.json https://raw.githubusercontent.com/cosmos/nightly-stack/refs/heads/main/long-lived-testnets/052-1/genesis.json

# Start the node
./cosmos-sdk-v0.52.x-mods-<os>-<arch> start

> Note: Replace <os>, <arch>, and <moniker> with your operating system, architecture, and desired node name respectively.
```

## Utilities

| Service        | URL                                          |
| -------------- | -------------------------------------------- |
| Block Explorer | `https://explorer-testnet.interchainsdk.io/` |
| Faucet         | `https://faucet-testnet.interchainsdk.io/`   |
