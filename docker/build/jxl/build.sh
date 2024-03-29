#!/bin/bash
set -e
set -o pipefail

git-shallow-clone "${JXL_TAG}" "${JXL_REPO}" /src/libjxl
pushd /src/libjxl

mkdir b
pushd b

cmake .. -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr \
-DJPEGXL_ENABLE_FUZZERS=0 \
-DJPEGXL_ENABLE_TOOLS=0 \
-DJPEGXL_ENABLE_DOXYGEN=0 \
-DJPEGXL_ENABLE_MANPAGES=0 \
-DJPEGXL_ENABLE_BENCHMARK=0 \
-DJPEGXL_ENABLE_EXAMPLES=0 \
-DJPEGXL_BUNDLE_LIBPNG=1 \
-DJPEGXL_ENABLE_JNI=0 \
-DJPEGXL_ENABLE_SKCMS=1 \
-DJPEGXL_BUNDLE_SKCMS=1 \
-DJPEGXL_STATIC=1 \
-DBUILD_TESTING=0 \
&& \
make -j$(nproc)
make install