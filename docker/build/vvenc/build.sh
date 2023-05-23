#!/bin/bash
set -e
set -o pipefail

git-shallow-clone "${VVENC_TAG}" "${VVENC_REPO}" /src/vvenc
pushd /src/vvenc
mkdir b
pushd b
cmake .. -DVVENC_ENABLE_X86_SIMD=ON -DBUILD_SHARED_LIBS=OFF -DVVENC_ENABLE_LINK_TIME_OPT=ON -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON -DCMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX:PATH=/usr && \
make -j$(nproc)
make install