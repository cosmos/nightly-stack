#!/usr/bin/env bash

set -Eeuo pipefail
set -x

# Import go modules
cd ${MATRIX_APP_REPOSITORY}/${MATRIX_APP_PATH}
go mod tidy

upgrade_name="v050-to-v052"
sed -i "/app\.UpgradeKeeper = upgradekeeper\.NewKeeper/ a \\\tapp.upgradeKeeper.SetUpgradeHandler(\"${upgrade_name}\", func(ctx sdk.Context, plan upgrade.Plan) {}" ~/cosmos-sdk/simapp/app.go

# Build application
cd ../..
make install
