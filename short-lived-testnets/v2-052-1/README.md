# Chain Details: `v2-052-1`

## Basic Information

- **Chain-ID:** `v2-052-1`
- **Denom:** `stake`
- **Application:** [Simapp - Cosmos-SDK v0.52.x](https://github.com/cosmos/cosmos-sdk/tree/release/v0.52.x/simapp)
- **Binary:** [Download Latest Build](https://github.com/cosmos/nightly-stack/actions/workflows/nightlies-scheduled.yaml)
  - Filename: `cosmos-sdk-v2-v0.52.x-mods-<os>-<arch>`
- **Genesis File:** `genesis.json`
  - SHA256: `5198b5d07482f37d949f65eddbf21b3f554e5a11ec571930b6b1fbcf25fb694f`
- **Launch Date:** 2025-01-31

## Network Endpoints

| Service | Endpoint                                                                               |
| ------- | -------------------------------------------------------------------------------------- |
| RPC     | `https://v2-052-1-testnet-rpc.interchainsdk.io:443`                                    |
| gRPC    | `v2-052-1-testnet-grpc.interchainsdk.io:443`                                           |
| REST    | `https://v2-052-1-testnet-rest.interchainsdk.io:443`                                   |
| Seed    | `d2c84c10d3ea3d5d700cb98b63547e084b40f381@v2-052-1-testnet-p2p.interchainsdk.io:20256` |

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
