# Nightly Build

![Knight Battle testing](./knightly.jpeg)

This repository contains the nightly builds of the Interchain Stack. The Interchain Stack is a collection of software that enables the creation of decentralized applications that are interoperable with other blockchains. The stack includes the Cosmos SDK, IBC, and CW.

## Workflows description

### Workflow #1 - Release Cosmos-SDK
- Application: SimApp from `cosmos/cosmos-sdk`
- Dependencies:
  - cosmos-sdk release/v0.50.x
  - cosmos-sdk release/v0.52.x
  - cometbft main
- Outputs:
  - Workflow artifacts
  - Container image

### Workflow #2 - Test Cosmos-SDK / Comet
- Application: SimAp from `cosmos/cosmos-sdk`
- Dependencies:
  - cosmos-sdk HEAD/main
  - cometbft HEAD/main

### Workflow #3 - Release Cosmos-SDK / IBC
- Application: SimApp from `cosmos/ibc-go`
- Dependencies:
  - cosmos-sdk release/v0.50.x
  - cosmos-sdk modules forced on release/v0.50.x
