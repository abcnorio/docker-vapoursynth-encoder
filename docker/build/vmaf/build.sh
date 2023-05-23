#!/bin/bash
set -e
set -o pipefail

git-shallow-clone "${VMAF_TAG}" "${VMAF_REPO}" /src/vmaf
pushd /src/vmaf/libvmaf
meson setup build . --prefix /usr --buildtype release -Denable_float=true
ninja -vC build
ninja -vC build install