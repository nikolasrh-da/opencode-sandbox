#!/bin/sh
set -eu

prefix=/opt/dotnet-node-toolchain
mkdir -p /usr/local/bin

# The sandbox has its own filesystem. These links make commands available to
# non-interactive OpenCode tool calls as well as interactive shells.
ln -sfn "$prefix/dotnet/dotnet" /usr/local/bin/dotnet
ln -sfn "$prefix/node/bin/node" /usr/local/bin/node
ln -sfn "$prefix/node/lib/node_modules/npm/bin/npm-cli.js" /usr/local/bin/npm
ln -sfn "$prefix/node/lib/node_modules/npm/bin/npx-cli.js" /usr/local/bin/npx
for tool in pnpm pnpx codegraph rtk; do
  ln -sfn "$prefix/bin/$tool" "/usr/local/bin/$tool"
done

dotnet --version
node --version
pnpm --version
codegraph --version
rtk --version
