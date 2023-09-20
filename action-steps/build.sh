#!/bin/bash

set -e
set -o nounset

TOOLS_DIR=${GITHUB_WORKSPACE}/tools
REPOS_DIR=${GITHUB_WORKSPACE}/repos
PKG_DIR=${GITHUB_WORKSPACE}/source

cmd () {
	${TOOLS_DIR}/ulos-runner ${TOOLS_DIR}/liblua ${TOOLS_DIR}/upt/src/bin/$1.lua "$@"
}

repo=${INPUT_REPO}
pkgname=${INPUT_PKGNAME}
prebuild="${INPUT_PREBUILD:-}"

cd $PKG_DIR

if [ "$prebuild" ]; then
	# todo - pass $PKG_DIR and branch name
	bash -ec "$prebuild"
fi

#touch ${REPOS_DIR}/$repo/packages.upl

rm -vf *.mtar
cmd uptb # | tail -n 1 >> ${REPOS_DIR}/$repo/packages.upl

mkdir -p ${REPOS_DIR}/$repo
cp *.mtar ${REPOS_DIR}/$repo/
