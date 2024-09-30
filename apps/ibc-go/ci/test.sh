#!/usr/bin/env bash

set -oue pipefail
set -x

# Set the timeout to 60 seconds
TIMEOUT=60
START_TIME=$(date +%s)

cd ${MATRIX_APP_REPOSITORY}
make init-simapp
./simd start > ./output.log 2>1 &
APP_PID=$!


while true; do
  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

  if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
    echo "Timeout reached. Application did not produce the success pattern within 60 seconds."
    kill $APP_PID
    cat ./output.log
    exit 1
  fi

  # Check that 4th block is produced to validate the application
  if simd query block-results 4; then
    echo "Block #4 has been committed. Application is working correctly."
    kill $APP_PID
    exit 0
  else
    echo "Block height is not greater than 4."
  fi

  sleep 3
done