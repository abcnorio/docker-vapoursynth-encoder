#!/bin/bash
set -e
set -o pipefail

git-shallow-clone "${ZENLIB_TAG}" "https://github.com/MediaArea/ZenLib.git" /src/ZenLib
pushd /src/ZenLib/Project/GNU/Library
./autogen.sh
./configure --enable-static --prefix=/usr
make -j$(nproc)
make install

git-shallow-clone "${MEDIAINFOLIB_TAG}" "https://github.com/MediaArea/MediaInfoLib.git" /src/MediaInfoLib
pushd /src/MediaInfoLib/Project/GNU/Library
./autogen.sh
./configure --enable-staticlibs --enable-static --prefix=/usr
make -j$(nproc)
make install

git-shallow-clone "${MEDIAINFO_TAG}" "https://github.com/MediaArea/MediaInfo.git" /src/MediaInfo
pushd /src/MediaInfo/Project/GNU/CLI
./autogen.sh
./configure --enable-staticlibs --prefix=/usr
make -j$(nproc)
make install