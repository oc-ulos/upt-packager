#!/bin/bash

set -e
oldpwd=$PWD

if ! [ $(whoami) = "root" ]; then
	printf "must be run as root\n" 1>&2
	exit 1
fi

mkdir -p /opt/ulos2/packages/

if ! [ -d /opt/ulos2/liblua ]; then
	git clone https://github.com/oc-ulos/liblua.git /opt/ulos2/liblua
else
	cd /opt/ulos2/liblua
	git pull
fi

if ! [ -d /opt/ulos2/upt ]; then
	git clone https://github.com/oc-ulos/upt.git /opt/ulos2/upt
else
	cd /opt/ulos2/upt
	git pull
fi

curl https://raw.githubusercontent.com/oc-ulos/ulos-2/dev/tools/ulos-runner > /opt/ulos2/ulos-runner
chmod +x /opt/ulos2/ulos-runner

cmd () {
	/opt/ulos2/ulos-runner /opt/ulos2/liblua /opt/ulos2/upt/src/bin/$1.lua "$@"
}

rm -rvf /opt/ulos2/repos

package () {
	pkgname=$1
	giturl=$2
  branch=$3
	prebuild="$4"

	if [ -d /opt/ulos2/packages/$pkgname-$branch ]; then
		cd /opt/ulos2/packages/$pkgname-$branch
    git checkout $branch
		git pull
	else
		git clone $giturl /opt/ulos2/packages/$pkgname-$branch
	fi

	cd /opt/ulos2/packages/$pkgname-$branch
  git checkout $branch
	if [ "$prebuild" ]; then
		$prebuild $pkgname $branch
	fi

	mkdir -p /opt/ulos2/repos/$repo
	touch /opt/ulos2/repos/$repo/packages.upl

	rm -vf *.mtar
	cd /opt/ulos2/packages/$pkgname-$branch
	cmd uptb | tail -n 1 >> /opt/ulos2/repos/$repo/packages.upl
	mkdir -p /opt/ulos2/repos/$repo/
	cp *.mtar /opt/ulos2/repos/$repo/
}

push () {
	sudo --user=ocawesome101 scp -r /opt/ulos2/repos/$repo $1/
}

cd $oldpwd
. config

