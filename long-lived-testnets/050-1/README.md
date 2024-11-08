
# `050-1` Chain Details

* **Chain-ID**: `050-1`
* **denom**: `stake`
* **Application**: [`Simapp - Cosmos-SDK v0.50.x`](https://github.com/cosmos/cosmos-sdk/tree/release/v0.50.x/simapp)
* **Binary**: [Download from latest workflow execution](https://github.com/cosmos/nightly-stack/actions/workflows/nightlies-scheduled.yaml) - Filename : `cosmos-sdk-v0.50.x-mods-<os>-<arch>`
* **Genesis File:**  genesis.json, verify with `shasum -a 256 genesis.json`
* **Genesis sha256sum**: `1cfe8633bcbf23b910d9c79a1563c49dc4132af94452b237099aff7a37c8d08b`
* Launch Date: 2024-31-04

## Endpoints

### API

`https://050-1-testnet-api.interchainsdk.io:443`


### gRPC

`050-1-testnet-grpc.interchainsdk.io:443`


### RPC

`https://050-1-testnet-rpc.interchainsdk.io:443`


### Seed

`5164d2523f7ffec3bbfdd9cf49b638477bdb53bc@050-1-testnet-p2p.interchainsdk.io:20056`


## How to join

```bash
./cosmos-sdk-v0.50.x-mods-<os>-<arch> init <moniker> --chain-id "050-1"
wget --quiet --output-document ~/.simapp/config/genesis.json https://raw.githubusercontent.com/cosmos/nightly-stack/refs/heads/main/long-lived-testnets/050-1/genesis.json
./cosmos-sdk-v0.50.x-mods-<os>-<arch> start
```


## Utilities

### Block Explorers

`https://explorer-testnet.interchainsdk.io/`


### Faucet

`https://faucet-testnet.interchainsdk.io/`
