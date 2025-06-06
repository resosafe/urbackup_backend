#!/bin/bash
set -e


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


GIT_SERVER_REPOSITORY="git@github.com:resosafe/urbackup_backend.git"
BRANCH="resosafe_2.5.x"
DEST_DIR="$SCRIPT_DIR/urbackup_backend_build"

cd $SCRIPT_DIR

rm -rf $DEST_DIR

git clone $GIT_SERVER_REPOSITORY $DEST_DIR
cd $DEST_DIR
git checkout $BRANCH


./switch_build.sh server
cd resosafe
python3 replace_versions.py version.json
cd ..

# install cryptopp
CRYPTOPP_PATH="$DEST_DIR/resosafe/3rdparty/cryptopp700.zip"
EXPECTED_SHA256="a4bc939910edd3d29fb819a6fc0dfdc293f686fa62326f61c56d72d0a366ceb0"
SHASUM=`shasum -a 256 "$CRYPTOPP_PATH" | cut -d" " -f1`

if [ $SHASUM != $EXPECTED_SHA256 ]
then
	echo "SHASUM of $CRYPTOPP_PATH is wrong: got $SHASUM expected $EXPECTED_SHA256"
	exit 1
fi
unzip -o "$CRYPTOPP_PATH" -d "$DEST_DIR/cryptoplugin/src"
rm -f GNUmakefile



autoreconf || true
automake --add-missing || true
autoreconf --install
./configure --enable-embedded-cryptopp

make
make dist