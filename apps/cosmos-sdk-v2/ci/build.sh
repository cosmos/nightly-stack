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
cd ${MATRIX_APP_REPOSITORY}/${MATRIX_APP_PATH}
go mod tidy

# Build application
cd ..
make install
