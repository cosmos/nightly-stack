#!/usr/bin/env bash

set -Eeuo pipefail
set -x

# Check if the architecture is arm64
if [ "$(uname -m)" = "aarch64" ]; then
    # Install the required packages
    sudo apt-get install gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu
fi

# Import go modules
cd ${MATRIX_APP_REPOSITORY}/${MATRIX_APP_PATH}
go mod tidy

# Build application
cd ../..
COSMOS_BUILD_OPTIONS=sqlite make install
