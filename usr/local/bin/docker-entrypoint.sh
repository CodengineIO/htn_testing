#!/usr/bin/env bash
set -e

# Usage: cardano-node
#                     --config NODE-CONFIGURATION
#                     --topology FILEPATH
#                     --database-path FILEPATH
#                     --socket-path FILEPATH
#                     [--host-addr HOST-NAME]
#                     --port PORT
#                     [--delegation-certificate FILEPATH]
#                     [--signing-key FILEPATH]
#                     --genesis-file FILEPATH

# shellcheck disable=SC1091
source /usr/local/lib/cardano-node-set-env-variables.sh

function preExitHook() {
  exec "$@"
  echo 'Exiting...'
}

if [[ ! -f "${CARDANO_NODE_GENESIS_FILE}" ]]; then
  echo "'cardano-node' Genesis file does not exist! 'cardano-node' can NOT start!!!"
  preExitHook "$@"
  exit
elif [[ ! -f "${CARDANO_NODE_CONF_FILE}" ]]; then
  echo "'cardano-node' Config file does not exists! 'cardano-node' can NOT start!!!"
  preExitHook "$@"
  exit
elif [[ ! -f "${CARDANO_NODE_TOPOLOGY_FILE}" ]]; then
  echo "'cardano-node' Topology file does not exists! 'cardano-node' can NOT start!!!"
  preExitHook "$@"
  exit
else
  cardano-node run \
    --config "${CARDANO_NODE_CONF_FILE}" \
    --topology "${CARDANO_NODE_TOPOLOGY_FILE}" \
    --database-path "${CARDANO_NODE_DB_PATH}" \
    --socket-path "${CARDANO_NODE_SOCKET_PATH}"/"${CARDANO_NODE_SOCKET}" \
    --port "${CARDANO_NODE_PORT}"
  # --genesis-file "${CARDANO_NODE_GENESIS_FILE}" \
fi
