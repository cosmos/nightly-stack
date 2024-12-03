#!/usr/bin/env bash

set -Eeuo pipefail
set -x

if [[ ${GOARCH} == "arm64" ]]; then
    export CC=aarch64-linux-gnu-gcc
    export CGO_ENABLED=1
    export GOOS=linux
fi

# Install CORSS tools
sudo apt install gcc-aarch64-linux-gnu

# Import go modules
cd "${MATRIX_APP_REPOSITORY}/${MATRIX_APP_PATH}"
go mod tidy

# See https://github.com/CosmWasm/wasmvm/releases
sudo wget --output-document /lib/libwasmvm.x86_64.so https://github.com/CosmWasm/wasmvm/releases/download/v2.2.0-rc.2/libwasmvm.x86_64.so
sudo wget --output-document /lib/libwasmvm.aarch64.so https://github.com/CosmWasm/wasmvm/releases/download/v2.2.0-rc.2/libwasmvm.aarch64.so

# Build application
LEDGER_ENABLED=false make build
