#!/bin/bash
set -e
set -o pipefail

git-shallow-clone "${SVT_TAG}" "${SVT_REPO}" /src/svt-av1
pushd /src/svt-av1
./Build/linux/build.sh --enable-avx512 --enable-lto --static --native --release --install --prefix /usr