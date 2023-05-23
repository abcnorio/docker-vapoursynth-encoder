#!/bin/bash
set -e
set -o pipefail

git-shallow-clone "${MAGICK_TAG}" "https://github.com/ImageMagick/ImageMagick" /src/imagemagick
cd /src/imagemagick
./configure --with-magick-plus-plus --prefix=/usr
make -j$(nproc)
make install
