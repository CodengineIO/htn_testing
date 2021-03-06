#!/bin/bash

# update the URL here if needed in the future
FF_FETCH_URL="https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html"

## DON'T EDIT PAST THIS POINT ##
# let's make sure cURL is installed
if ! command -v curl >/dev/null; then
    echo "cURL not found. please install curl!"
    exit 1
fi

# let's make sure lynx is installed
if ! command -v lynx >/dev/null; then
    echo "lynx not found. please install lynx!"
    exit 2
fi

# create a temporary file for the html dump
tmpFile="ff.html"
touch "$tmpFile"

# get the latest build info from hydra.iohk.io
lynx -dump -listonly "$FF_FETCH_URL" >"$tmpFile"
# latest build id
FF_BUILD_ID=$(awk '/ff/ {print $2}' "$tmpFile" | sed 's/[a-zA-Z\:\/\.\-]//g' | sort -u)
# ff-config.json
FF_CONF_URL=$(awk '/ff-config/ {print $2}' "$tmpFile")
FF_CONF_FILE="${FF_BUILD_ID}/ff-config.json"
# ff-genesis.json
FF_GENE_URL=$(awk '/ff-genesis/ {print $2}' "$tmpFile")
FF_GENE_FILE="${FF_BUILD_ID}/ff-genesis.json"
# ff-topology.json
FF_TOPO_URL=$(awk '/ff-topology/ {print $2}' "$tmpFile")
FF_TOPO_FILE="${FF_BUILD_ID}/ff-topology.json"

# we don't need the temporary file anymore
rm -f "$tmpFile"

# create latest build directory
if [[ ! -d "${FF_BUILD_ID}" ]]; then
    mkdir "${FF_BUILD_ID}"
fi

# let's check if the files are already available and exit
if [[ -f "$FF_CONF_FILE" ]] && [[ -f "$FF_GENE_FILE" ]] && [[ -f "$FF_TOPO_FILE" ]]; then
    echo "You already have the latest configurations. Nothing to do here"
    exit 3
# otherwise go get'em
else
    # download the files into the build directory
    curl -sLJ "${FF_CONF_URL}" -o "$FF_CONF_FILE"
    curl -sLJ "${FF_GENE_URL}" -o "$FF_GENE_FILE"
    curl -sLJ "${FF_TOPO_URL}" -o "$FF_TOPO_FILE"
fi

exit 0
