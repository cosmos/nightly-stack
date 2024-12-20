# Chain Details: `v2-052-1`

## Basic Information

- **Chain-ID:** `v2-052-1`
- **Denom:** `stake`
- **Application:** [Simapp - Cosmos-SDK v0.52.x](https://github.com/cosmos/cosmos-sdk/tree/release/v0.52.x/simapp)
- **Binary:** [Download Latest Build](https://github.com/cosmos/nightly-stack/actions/workflows/nightlies-scheduled.yaml)
  - Filename: `cosmos-sdk-v2-v0.52.x-mods-<os>-<arch>`
- **Genesis File:** `genesis.json`
  - SHA256: `db86bc420fb76b4d06207ef97c3a1c8ceb4acf3a4f5626a6dca528a1b8a6a597`
- **Launch Date:** 2024-12-20

## Network Endpoints

| Service | Endpoint                                                                               |
| ------- | -------------------------------------------------------------------------------------- |
| RPC     | `https://v2-052-1-testnet-rpc.interchainsdk.io:443`                                    |
| gRPC    | `v2-052-1-testnet-grpc.interchainsdk.io:443`                                           |
| REST    | `https://v2-052-1-testnet-rest.interchainsdk.io:443`                                   |
| Seed    | `95eba83365b1bca3f3152feb5a063bff0f11af28@v2-052-1-testnet-p2p.interchainsdk.io:20256` |

## Join the Network

To join the network, execute the following commands:

```bash
# Initialize the node
./cosmos-sdk-v2-v0.52.x-mods-<os>-<arch> init <moniker> --chain-id v2-052-1

# Download genesis file
wget --quiet --output-document ~/.simappv2/config/genesis.json https://raw.githubusercontent.com/cosmos/nightly-stack/refs/heads/main/short-lived-testnets/v2-052-1/genesis.json

# Start the node
./cosmos-sdk-v2-v0.52.x-mods-<os>-<arch> start

> Note: Replace <os>, <arch>, and <moniker> with your operating system, architecture, and desired node name respectively.
```
