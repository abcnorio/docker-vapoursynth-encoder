#!/bin/bash
set -e
set -o pipefail

git-shallow-clone "${FDKAAC_TAG}" "${FDKAAC_REPO}" /src/fdk-aac
pushd /src/fdk-aac
mkdir b
pushd b
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_PROGRAMS=ON -DBUILD_SHARED_LIBS=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr && \
make -j$(nproc)
make install