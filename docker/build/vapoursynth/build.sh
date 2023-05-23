#!/bin/bash
set -e
set -o pipefail


git-shallow-clone "${VS_TAG}" "https://github.com/vapoursynth/vapoursynth.git" /src/vapoursynth
pushd /src/vapoursynth
./autogen.sh
mkdir /usr/lib/vapoursynth
./configure --enable-plugins --disable-ocr --prefix=/usr
make -j$(nproc)
make install