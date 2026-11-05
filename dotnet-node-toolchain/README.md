# OpenCode sandbox toolchain

Docker Sandboxes v3 mixin for Apple Silicon: .NET, Node.js, pnpm, CodeGraph
and RTK.

Run the commands from the directory containing `dotnet-node-toolchain/`.
You need Docker with Buildx and Docker Sandboxes `sbx`, signed in to Docker.

## Build and test

Build the mixin:

```sh
docker buildx build --pull --no-cache ./dotnet-node-toolchain \
  -f ./dotnet-node-toolchain/dotnet-node-toolchain.yaml \
  --output type=cacheonly
```

For GitHub Copilot, store a GitHub credential for an account with Copilot
access before creating the sandbox (skip this if it is already stored):

```sh
sbx secret set github
```

If `.env` doesn't exist, create it from the example and set `PROJECT_NAME` and
`PROJECT_FOLDER`:

```sh
cp .env.example .env
```

Create the sandbox with the mixin and approve the GitHub credential binding if
prompted:

```sh
sbx run ./run.sh --kit ./dotnet-node-toolchain
```

Test the installed tools from another terminal:

```sh
sbx exec my-project -- sh -c \
  'opencode --version && dotnet --version && node --version && pnpm --version && codegraph --version && rtk --version'
sbx exec my-project -- sh -c 'test -s "$HOME/.config/opencode/plugins/rtk.ts" && rtk hook opencode --help && rtk gain'
```

Send a prompt using a GitHub Copilot model in OpenCode to test authentication.
Use the project name from `.env` in place of `my-project` in the checks above.
Run `./run.sh` again to reattach to the existing sandbox.

The build command validates the mixin; `sbx run` builds the local source kit
separately. Existing sandboxes keep their original kits, and `sbx` can cache
local source kits.

## RTK

The mixin installs RTK's OpenCode plugin and disables RTK telemetry. Ask
OpenCode to run a command such as `git status`, then check
`sbx exec my-project -- rtk gain` for activity.

Tool versions are selected by the mixin's Dockerfile. RTK's installer verifies
its release checksum.

## Codegraph

Codegraph is installed but not configured. The mounted repository needs to provide its own configuration.
