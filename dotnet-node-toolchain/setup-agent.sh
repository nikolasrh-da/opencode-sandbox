#!/bin/sh
set -eu

# The upstream installer writes the plugin into the agent's OpenCode config
# directory, not into the workload-managed opencode.json.
/usr/local/bin/rtk telemetry disable
/usr/local/bin/rtk init --global --opencode --no-patch --no-trust-filters
test -s "$HOME/.config/opencode/plugins/rtk.ts"
