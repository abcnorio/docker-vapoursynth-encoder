#!/bin/bash
set -e
set -o pipefail


git-shallow-clone "${ZIMG_TAG}" "https://github.com/sekrit-twc/zimg.git" /src/zimg
pushd /src/zimg
./autogen.sh
./configure --enable-example --enable-simd --enable-shared --enable-static --prefix=/usr
make -j$(nproc)
make install