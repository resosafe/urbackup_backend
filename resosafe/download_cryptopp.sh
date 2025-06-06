#!/bin/sh

set -e

cd "$(dirname "$0")"

CRYPTOPP_NAME="cryptopp700.zip"
EXPECTED_SHA256="a4bc939910edd3d29fb819a6fc0dfdc293f686fa62326f61c56d72d0a366ceb0"


SHASUM=`shasum -a 256 "3rdparty/$CRYPTOPP_NAME" | cut -d" " -f1`
if [ $SHASUM != $EXPECTED_SHA256 ]
then
	echo "SHASUM of $CRYPTOPP_NAME is wrong: got $SHASUM expected $EXPECTED_SHA256"
	exit 1
fi
unzip -o "3rdparty/$CRYPTOPP_NAME" -d ../cryptoplugin/src
rm GNUmakefile

cd -
