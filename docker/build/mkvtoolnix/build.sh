#!/bin/bash
set -e
set -o pipefail

git-shallow-clone "${MKVTOOLNIX_TAG}" "${MKVTOOLNIX_REPO}" /src/mkvtoolnix
pushd /src/mkvtoolnix
./autogen.sh
./configure --enable-static --disable-gui --disable-qt6 --enable-qt5 --with-qt-pkg-config --enable-static-qt --enable-precompiled-headers --disable-update-check --prefix=/usr
rake -j$(nproc)
rake install