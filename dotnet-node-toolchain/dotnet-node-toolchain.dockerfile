# syntax=docker/dockerfile:1

# Use official toolchain images for Linux ARM64 sandboxes on Apple Silicon.
FROM mcr.microsoft.com/dotnet/sdk:10.0-noble AS dotnet
FROM node:24-trixie-slim AS tools

ARG TARGETARCH
ENV PATH="/opt/dotnet-node-toolchain/bin:${PATH}"

# Install into a private prefix rather than replacing files in the workload.
RUN test "$TARGETARCH" = arm64 \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates \
    && mkdir -p /opt/dotnet-node-toolchain/bin \
    && npm install --global --allow-scripts=pnpm --prefix /opt/dotnet-node-toolchain \
      pnpm@latest @colbymchenry/codegraph@latest \
    && curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh -o /tmp/rtk-install.sh \
    && RTK_INSTALL_DIR=/opt/dotnet-node-toolchain/bin sh /tmp/rtk-install.sh \
    && rm /tmp/rtk-install.sh \
    && node --version \
    && /opt/dotnet-node-toolchain/bin/pnpm --version \
    && /opt/dotnet-node-toolchain/bin/codegraph --version \
    && /opt/dotnet-node-toolchain/bin/rtk --version

# The mixin contains only its own files. Install hooks add command symlinks
# after it has been combined with the OpenCode workload.
FROM scratch
COPY --from=dotnet /usr/share/dotnet/ /opt/dotnet-node-toolchain/dotnet/
COPY --from=tools /usr/local/bin/node /opt/dotnet-node-toolchain/node/bin/node
COPY --from=tools /usr/local/lib/node_modules/npm/ /opt/dotnet-node-toolchain/node/lib/node_modules/npm/
COPY --from=tools /opt/dotnet-node-toolchain/ /opt/dotnet-node-toolchain/
COPY setup-system.sh setup-agent.sh /opt/dotnet-node-toolchain/
