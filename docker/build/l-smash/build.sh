#!/bin/bash
set -e
set -o pipefail

git-shallow-clone "master" "https://github.com/l-smash/l-smash" /src/l-smash
pushd /src/l-smash
./configure --prefix=/usr --extra-cflags="-fPIC" --extra-ldflags="-fPIC"
make -j$(nproc)
make install