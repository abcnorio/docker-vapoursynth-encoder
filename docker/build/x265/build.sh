#!/bin/bash
set -e
set -o pipefail

git-shallow-clone "${X265_TAG}" "${X265_REPO}" /src/x265
pushd /src/x265/build/linux
MAKEFLAGS=-j$(nproc) /multilib.sh
cp 8bit/x265 /usr/bin/x265
