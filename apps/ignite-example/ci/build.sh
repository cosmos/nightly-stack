#!/usr/bin/env bash

set -Eeuo pipefail
set -x

# Install go
# apt update && apt install -y curl wget git
# wget https://go.dev/dl/go1.23.1.linux-amd64.tar.gz
# tar -C /usr/local -xzf go1.23.1.linux-amd64.tar.gz
# export PATH=$PATH:/usr/local/go/bin
# rm go1.23.1.linux-amd64.tar.gz
# cd ~
# git clone https://github.com/auricom/example.git
# cd ~/example

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