#!/bin/bash

# let's make sure cURL is installed
if ! command -v curl >/dev/null; then
    echo "cURL not found. please install curl!"
    exit 1
fi

# let's make sure lynx is installed
if ! command -v lynx >/dev/null; then
    echo "lynx not found. please install lynx!"
    exit 1
fi

# create a temporary file for the html dump
tmpFile="myff.html"
touch "$tmpFile"

# get the latest build info from hydra.iohk.io
lynx -dump -listonly https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html >"$tmpFile"

# latest build id
FF_BUILD_ID=$(awk '/ff/ {print $2}' "$tmpFile" | sed 's/[a-zA-Z\:\/\.\-]//g' | sort -u)
# ff-config.json
FF_CONF_URL=$(awk '/ff-config/ {print $2}' "$tmpFile")
# ff-genesis.json
FF_GENE_URL=$(awk '/ff-genesis/ {print $2}' "$tmpFile")
# ff-topology.json
FF_TOPO_URL=$(awk '/ff-topology/ {print $2}' "$tmpFile")

# create latest build directory
if [[ ! -d "${FF_BUILD_ID}" ]]; then
    mkdir "${FF_BUILD_ID}"
fi

# download the files into the build directory
curl -sLJ "${FF_CONF_URL}" -o "${FF_BUILD_ID}"/ff-config.json
curl -sLJ "${FF_GENE_URL}" -o "${FF_BUILD_ID}"/ff-genesis.json
curl -sLJ "${FF_TOPO_URL}" -o "${FF_BUILD_ID}"/ff-topology.json

# we protecc, we clean up
rm -f "$tmpFile"

exit 0
