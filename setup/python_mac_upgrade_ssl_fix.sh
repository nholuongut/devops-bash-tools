#!/usr/bin/env bash
#

# from https://stackoverflow.com/questions/24287239/abort-trap-6-when-running-a-python-script

set -euo pipefail

sudo=""
[ $EUID -eq 0 ] || sudo=sudo

#brew update && brew upgrade && brew install openssl
cd /usr/local/Cellar/openssl/*/lib
sudo cp -- libssl.1.0.0.dylib libcrypto.1.0.0.dylib /usr/local/lib/
cd /usr/local/lib
[ -f libssl.dylib ] ||
    $sudo ln -s -- libssl.1.0.0.dylib libssl.dylib
[ -f libcrypto.dylib ] ||
    $sudo ln -s -- libcrypto.1.0.0.dylib libcrypto.dylib
#pip3 install --upgrade packagename
