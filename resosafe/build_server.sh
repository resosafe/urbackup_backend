#!/bin/bash
set -e

GIT_SERVER_REPOSITORY="git@github.com:resosafe/urbackup_backend.git"
BRANCH="2.5.x_resosafe"


cd "$(dirname "$0")"

rm -rf tmp
mkdir tmp
cd tmp

git clone $GIT_SERVER_REPOSITORY
cd urbackup_backend
git checkout $BRANCH


./switch_build.sh server
cd resosafe
python3 replace_versions.py ../version.json
./download_cryptopp.sh

cd ..

if ! test -e build_server_ok
then
	
	autoreconf || true
	automake --add-missing || true
	autoreconf --install
	./configure --enable-embedded-cryptopp
	touch build_server_ok
fi


make
make dist