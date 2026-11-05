#!/bin/sh
set -eu

cd "$(dirname "$0")"

source .env

if sbx ls --quiet | grep -q "$PROJECT_NAME"; then
  exec sbx run \
    --name "$PROJECT_NAME" \
    -e "OPENCODE_CONFIG=/home/agent/sandbox-config/opencode.json" \
    "$@"
else
  exec sbx run docker.io/sbx/opencode:1.18.31 \
    --kit ./dotnet-node-toolchain \
    --name "$PROJECT_NAME" \
    --clone \
    -e "OPENCODE_CONFIG=/home/agent/sandbox-config/opencode.json" \
    "$PROJECT_FOLDER" \
    "sandbox-notes:/home/agent/sandbox-notes" \
    "sandbox-config:/home/agent/sandbox-config" \
    "$@"
fi
