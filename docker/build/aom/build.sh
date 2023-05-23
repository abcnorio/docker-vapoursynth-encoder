#!/bin/bash
set -e
set -o pipefail

git-shallow-clone "${AOM_TAG}" "${AOM_REPO}" /src/aom
pushd /src/aom

sed -i 's/MAX_NUM_THREADS 64/MAX_NUM_THREADS 128/' aom_util/aom_thread.h

#patch out libskcms as it's bundled in JXL
sed -i 's/find_library\(LIBSKCMS_LIBRARIES libskcms\.a\)//' CMakeLists.txt
sed -i 's/find_library\(LIBSKCMS_LIBRARIES libskcms\.a\)//' CMakeLists.txt
sed -i 's/AND LIBSKCMS_LIBRARIES//' CMakeLists.txt
mkdir b
pushd b

#todo: check DCONFIG_NN_V2 (neural network?)
#-DCONFIG_TUNE_BUTTERAUGLI=1 \
#-DSTATIC_LINK_JXL=1 \
cmake .. -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr \
-DENABLE_DOCS=OFF -DENABLE_EXAMPLES=ON -DENABLE_TOOLS=OFF -DENABLE_TESTS=OFF -DENABLE_CCACHE=ON \
-DCONFIG_FRAME_PARALLEL_ENCODE=1 \
-DCONFIG_AV1_TEMPORAL_DENOISING=1 \
-DCONFIG_BITRATE_ACCURACY=1 \
-DCONFIG_TUNE_VMAF=1 \
-DCONFIG_NN_V2=1 \
-DCONFIG_RT_ML_PARTITIONING=1 \
-DCONFIG_THREE_PASS=1 \
-DCONFIG_AV1_ENCODER=1 \
-DCONFIG_AV1_DECODER=1 \
&& \
make -j$(nproc)
make install