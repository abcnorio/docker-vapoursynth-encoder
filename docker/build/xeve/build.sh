#!/bin/bash
set -e
set -o pipefail

export CFLAGS="$CFLAGS -Wno-unknown-warning-option -Wno-error=parentheses-equality -Wno-error=empty-body -Wno-error=shift-negative-value -Wno-error=sometimes-uninitialized -Wno-error=typedef-redefinition -Wno-error=for-loop-analysis"
export CPPFLAGS="$CFLAGS"

git-shallow-clone "${XEVE_TAG}" "${XEVE_REPO}" /src/xeve
pushd /src/xeve
mkdir b
pushd b
cmake .. \
-DSET_PROF="${1}" \
-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
-DCMAKE_BUILD_TYPE=Release \
-DBUILD_SHARED_LIBS=OFF \
-DXEVE_APP_STATIC_BUILD=ON \
-D CMAKE_INSTALL_PREFIX:PATH=/usr && \
make -j$(nproc)
make install