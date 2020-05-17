#!/bin/bash

# shellcheck disable=SC2034

CARDANO_NODE_USER_HOME=$HOME

if [ -f "${CARDANO_NODE_USER_HOME}"/config/genesis.json ]; then
  CARDANO_NODE_GENESIS_FILE="${CARDANO_NODE_USER_HOME}"/config/genesis.json
fi

if [ -f "${CARDANO_NODE_USER_HOME}"/config/topology.json ]; then
  CARDANO_NODE_TOPOLOGY_FILE="${CARDANO_NODE_USER_HOME}"/config/topology.json
fi

if [ -f "${CARDANO_NODE_USER_HOME}"/config/config.json ]; then
  CARDANO_NODE_CONF_FILE="${CARDANO_NODE_USER_HOME}"/config/config.json
elif [ -f "${CARDANO_NODE_USER_HOME}"/config/config.yaml ]; then
  CARDANO_NODE_CONF_FILE="${CARDANO_NODE_USER_HOME}"/config/config.yaml
fi

: "${CARDANO_NODE_PORT:=${CARDANO_NODE_PORT:-3001}}"
: "${CARDANO_NODE_MAX_STARTUP_TIME:=${CARDANO_NODE_MAX_STARTUP_TIME:-20}}"
: "${CARDANO_NODE_MAX_FAULT_UPTIME:=${CARDANO_NODE_MAX_FAULT_UPTIME:-600}}"
