#!/bin/sh
set -eu

cd "$(dirname "$0")"

source .env

sbx exec "$PROJECT_NAME" -- dotnet --version
sbx exec "$PROJECT_NAME" -- node --version
sbx exec "$PROJECT_NAME" -- pnpm --version
sbx exec "$PROJECT_NAME" -- codegraph --version
sbx exec "$PROJECT_NAME" -- rtk --version
sbx exec "$PROJECT_NAME" -- opencode mcp list
sbx exec "$PROJECT_NAME" -- opencode plugin list
sbx exec "$PROJECT_NAME" -- rtk gain
