#!/usr/bin/env bash

set -Eeuo pipefail
set -x

# Import go modules
cd ${MATRIX_APP_REPOSITORY}/${MATRIX_APP_PATH}
go mod tidy

# Build application
cd ..
CGO_ENABLED=1 COSMOS_BUILD_OPTIONS=v2 make install
