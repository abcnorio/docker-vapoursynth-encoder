#!/bin/bash
set -e
set -o pipefail

git-shallow-clone "${1}" "${X264_REPO}" /src/x264
pushd /src/x264
CC=gcc CXX=g++ CFLAGS="-Ofast -march=native" CPPFLAGS="-Ofast -march=native" CXXFLAGS="-Ofast -march=native" LDFLAGS="" \
./configure --disable-ffms --disable-lavf --disable-swscale --enable-static --bit-depth=all --chroma-format=all --enable-lto --enable-pic --disable-opencl --prefix=/usr
make -j$(nproc)
make install