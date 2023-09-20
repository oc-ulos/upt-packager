#!/bin/bash

set -e
set -o nounset

REPOS_DIR=${GITHUB_WORKSPACE}/repos

# Create a temporary identity file.
echo "$INPUT_PUSH_IDENTITY" > ${GITHUB_WORKSPACE}/id
trap "rm -f ${GITHUB_WORKSPACE}/id" EXIT

# See https://serverfault.com/a/852310 for how to set this up
scp -i ${GITHUB_WORKSPACE}/id -r ${REPOS_DIR}/${INPUT_REPO} "${INPUT_PUSH_URL}"
