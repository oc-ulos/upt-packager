#!/bin/bash

set -e
set -o nounset

mkdir -p ${GITHUB_WORKSPACE}/packages

TOOLS_DIR=${GITHUB_WORKSPACE}/tools
rm -rf ${TOOLS_DIR}

git clone https://github.com/oc-ulos/liblua.git ${TOOLS_DIR}/liblua

git clone https://github.com/oc-ulos/upt.git ${TOOLS_DIR}/upt

curl https://raw.githubusercontent.com/oc-ulos/ulos-2/primary/tools/ulos-runner > ${TOOLS_DIR}/ulos-runner
chmod +x ${TOOLS_DIR}/ulos-runner
