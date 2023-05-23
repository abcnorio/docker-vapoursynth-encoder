#!/bin/bash
set -e
set -o pipefail

git-shallow-clone "${UVG266_TAG}" "${UVG266_REPO}" /src/uvg266
pushd /src/uvg266
mkdir b
pushd b
cmake .. \
-DGIT_SUBMODULE=OFF \
-DBUILD_SHARED_LIBS=OFF \
-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
-DCMAKE_BUILD_TYPE=Release \
-D CMAKE_INSTALL_PREFIX:PATH=/usr \
${UVG266_DEFS} \
&& \
make -j$(nproc)
make install