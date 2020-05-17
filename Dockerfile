## CARDANO NODE BUILDER CONTAINER
FROM ubuntu:20.04 AS builder

# Change the Cardano Node, Cabal, and GHC versions here
ENV CABAL_VERSION="3.2"
ENV GHC_VERSION="8.6.5"
ENV CARDANO_NODE_VERSION="1.11.0"

# GHC and Cabal from the official PPA - https://launchpad.net/~hvr/+archive/ubuntu/ghc
RUN apt-get update -y && apt-get install -y software-properties-common && add-apt-repository ppa:hvr/ghc
# Install build dependencies
RUN apt-get update -y && apt-get install -y build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ git cabal-install-${CABAL_VERSION} ghc-${GHC_VERSION}
# Set PATH and refresh Hackage
ENV PATH="/opt/ghc/bin:/opt/cabal/bin:${PATH}"
RUN cabal update

# Clone cardano node repo
WORKDIR /usr/local/src/
RUN git clone --recurse-submodules https://github.com/input-output-hk/cardano-node
# Fetch and checkout (tag to be decided or master)
WORKDIR /usr/local/src/cardano-node
# Unfortunately the pioneers' docs are a bit outdated at the moment (the latest pioneer's tag should do it)
RUN git fetch --tags
RUN git checkout tags/pioneer-2

# Build/Install
# This doesn't work yet
# RUN cabal install cardano-node cardano-cli
# So we use these instead
RUN cabal build all
RUN cp -f \
    ./dist-newstyle/build/x86_64-linux/ghc-${GHC_VERSION}/cardano-node-${CARDANO_NODE_VERSION}/x/cardano-node/build/cardano-node/cardano-node \
    ./dist-newstyle/build/x86_64-linux/ghc-${GHC_VERSION}/cardano-cli-${CARDANO_NODE_VERSION}/x/cardano-cli/build/cardano-cli/cardano-cli \
    /usr/local/bin/

## CARDANO NODE CONTAINER
FROM ubuntu:20.04 AS cardano-node

LABEL maintainer="Andrea Callea <gacallea@mailfence.com>" version="1.0"

# TZ DATA needs this to avoid the interactive setup (set your time zone in the docker-compose.yaml file)
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install some useful software (to be decided...)
RUN apt-get update -y && apt-get install -y bc cbm ccze chrony curl dnsutils htop jq iputils-ping libncursesw5 lsof net-tools ripgrep speedtest-cli sysstat tcptraceroute telnet tmux tree vim wget

# Copy the compiled cardano node software
COPY --from=builder /usr/local/bin/cardano-node /usr/local/bin/
COPY --from=builder /usr/local/bin/cardano-cli /usr/local/bin/
# Copy the entrypoint scripts
COPY usr/local/lib/* /usr/local/lib/
COPY usr/local/bin/* /usr/local/bin/
# Copy some customized config files
COPY etc/inputrc /etc/inputrc
COPY etc/tmux.conf /root/.tmux.conf

# Create the directory from where to run the cardano-node
RUN mkdir -p /srv/cardano/

# Create the user and group to run the cardano-node
RUN groupadd -r cnode
RUN useradd -c "Cardano node user" -m -d /srv/cardano/cardano-node -r -s /sbin/nologin -g cnode cnode

# Switch user (needed for the entrypoint variables to work)
USER cnode
ENV HOME=/srv/cardano/cardano-node

# Copy some customized config files
COPY etc/tmux.conf $HOME/.tmux.conf

# Create the need directory tree to host the cardano-node configurations
RUN mkdir $HOME/config/
RUN mkdir $HOME/db/
RUN mkdir $HOME/logs/
RUN mkdir $HOME/socket/

# Some ENV needed to be set for cli commands to work
ENV CARDANO_NODE_DB_PATH=$HOME/db/
ENV CARDANO_NODE_SOCKET_PATH=$HOME/socket/
ENV CARDANO_NODE_SOCKET=cardano-node.socket

# This one copies the common configs for core and relay
COPY --chown=cnode:cnode common/config/* $HOME/config/
# Only the topology differs in each node
COPY --chown=cnode:cnode core/config/topology.json $HOME/config/

WORKDIR /srv/cardano/cardano-node/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

## HERE we create a relay node with only what differs from the cardano-node image
FROM cardano-node AS cardano-relay

ENV CARDANO_NODE_SOCKET=cardano-relay.socket

# Only the topology differs in each node
COPY --chown=cnode:cnode relay/config/topology.json $HOME/config/

WORKDIR /srv/cardano/cardano-node/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
