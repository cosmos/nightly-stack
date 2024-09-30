#!/usr/bin/env bash

set -Eeuo pipefail
set -x

# Install ignite CLI
curl https://get.ignite.com/cli! | bash

# Allow non-interactive ignite CLI
mkdir ~/.ignite
echo '{"name":"cgsbraqtavklhebm","doNotTrack":true}' > ~/.ignite/anon_identity.json

# Import go modules
cd ${MATRIX_APP_REPOSITORY}/${MATRIX_APP_PATH}

go mod tidy

# Build application
ignite chain build -v