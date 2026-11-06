#!/bin/sh
set -eu

cd "$(dirname "$0")"

source .env

if sbx ls --quiet | grep -q "$PROJECT_NAME"; then
  exec sbx run \
    --name "$PROJECT_NAME" \
    --env-file .env.sandbox \
    -- -c
else
  exec sbx run docker.io/sbx/opencode:1.18.31 \
    --kit ./dotnet-node-toolchain \
    --name "$PROJECT_NAME" \
    --env-file .env.sandbox \
    --clone \
    "$PROJECT_FOLDER" \
    "/Users/nikolas/da-repos/k8s-applications:/home/agent/k8s-applications" \
    "sandbox-notes:/home/agent/sandbox-notes" \
    "sandbox-config:/home/agent/sandbox-config"
fi
