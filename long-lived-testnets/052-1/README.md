
# `052-1` Chain Details

* **Chain-ID**: `052-1`
* **denom**: `stake`
* **Application**: [`Simapp - Cosmos-SDK v0.52.x`](https://github.com/cosmos/cosmos-sdk/tree/release/v0.52.x/simapp)
* **Binary**: [Download from latest workflow execution](https://github.com/cosmos/nightly-stack/actions/workflows/nightlies-scheduled.yaml) - Filename : `cosmos-sdk-v0.52.x-mods-<os>-<arch>`
* **Genesis File:**  genesis.json, verify with `shasum -a 256 genesis.json`
* **Genesis sha256sum**: `338d368ad23941dffe5ce92799b766dc2aa4b4c53fb320f6fe648ff1b427612d`
* Launch Date: 2024-31-04

## Endpoints

### API

`https://052-1-testnet-api.interchainsdk.io:443`


### gRPC

`052-1-testnet-grpc.interchainsdk.io:443`


### RPC

`https://052-1-testnet-rpc.interchainsdk.io:443`


### Seed

`4fdd35e73406fb29af21a5ca2cd1637aaee9c45e@052-1-testnet-p2p.interchainsdk.io:20156`


## How to join

```bash
./cosmos-sdk-v0.52.x-mods-<os>-<arch> init <moniker> --chain-id "052-1"
wget --quiet --output-document ~/.simappv2/config/genesis.json https://raw.githubusercontent.com/cosmos/nightly-stack/refs/heads/main/long-lived-testnets/052-1/genesis.json
./cosmos-sdk-v0.52.x-mods-<os>-<arch> start
```


## Utilities

### Block Explorers

`https://explorer-testnet.interchainsdk.io/`


### Faucet

`https://faucet-testnet.interchainsdk.io/`
