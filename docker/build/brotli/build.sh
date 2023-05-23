#!/bin/bash
set -e
set -o pipefail

git-shallow-clone "${BROTLI_TAG}" "${BROTLI_REPO}" /src/brotli
pushd /src/brotli
mkdir b
pushd b

cmake .. -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr \
-DBROTLI_DISABLE_TESTS=ON \
&& \
make -j$(nproc)
make install