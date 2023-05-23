#!/bin/bash
set -e
set -o pipefail

curl https://raw.githubusercontent.com/dubhater/vapoursynth-fieldhint/v3/src/fieldhint.c | gcc -x c -I /usr/include/vapoursynth \
-shared -o /usr/lib/vapoursynth/fieldhint.so \
-O3 -fPIC \
-


git-shallow-clone "master" https://github.com/VFR-maniac/L-SMASH-Works.git /src/L-SMASH-Works
pushd /src/L-SMASH-Works
cd VapourSynth
./configure --vs-plugindir=/usr/lib/vapoursynth --prefix=/usr
make -j$(nproc)
make install

git-shallow-clone "v1.2" https://github.com/dwbuiten/d2vsource.git /src/d2vsource
pushd /src/d2vsource
./autogen.sh
./configure --prefix=/usr
make -j$(nproc)
cp .libs/libd2vsource.so /usr/lib/vapoursynth/

git-shallow-clone "r10.1" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-TDeintMod.git /src/VapourSynth-TDeintMod
pushd /src/VapourSynth-TDeintMod
./autogen.sh
./configure
make -j$(nproc)
cp .libs/libtdeintmod.so /usr/lib/vapoursynth/

git-shallow-clone "r28" https://github.com/EleonoreMizo/fmtconv.git /src/fmtconv
pushd /src/fmtconv
cd build/unix
./autogen.sh
./configure --prefix=/usr
make -j$(nproc)
cp .libs/libfmtconv.so /usr/lib/vapoursynth/

git-shallow-clone "v23" https://github.com/dubhater/vapoursynth-mvtools.git /src/vapoursynth-mvtools
pushd /src/vapoursynth-mvtools
./autogen.sh
./configure --prefix=/usr
make -j$(nproc)
cp .libs/libmvtools.so /usr/lib/vapoursynth/

git-shallow-clone "64323f0fdee4dd4fe429ee6287906dbae8e7571c" https://github.com/myrsloik/VapourSynth-FFT3DFilter.git /src/VapourSynth-FFT3DFilter
pushd /src/VapourSynth-FFT3DFilter
mkdir b
pushd b
meson ..
ninja
cp libfft3dfilter.so /usr/lib/vapoursynth/

git-shallow-clone "r2.1" https://github.com/sekrit-twc/znedi3.git /src/znedi3
pushd /src/znedi3
#TODO: remove X86 hardcode
make X86=1 -j$(nproc)
cp vsznedi3.so /usr/lib/vapoursynth/
cp nnedi3_weights.bin /usr/lib/vapoursynth/

git-shallow-clone "r7" https://github.com/Irrational-Encoding-Wizardry/descale.git /src/descale
pushd /src/descale
mkdir b
pushd b
meson ..
ninja
cp libdescale.so /usr/lib/vapoursynth/
cp ../descale.py /usr/lib/vapoursynth/

git-shallow-clone "master" https://github.com/SAPikachu/flash3kyuu_deband.git /src/flash3kyuu_deband
pushd /src/flash3kyuu_deband
sed -i 's/env python/env python3/' ./waf
./waf configure
./waf build
cp build/libf3kdb.so /usr/lib/vapoursynth/

git-shallow-clone "r9" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D.git /src/VapourSynth-BM3D
pushd /src/VapourSynth-BM3D
mkdir b
pushd b
LDFLAGS=-lfftw3f_threads meson ..
ninja
cp libbm3d.so /usr/lib/vapoursynth/

git-shallow-clone "r7" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DFTTest.git /src/VapourSynth-DFTTest
pushd /src/VapourSynth-DFTTest
mkdir b
pushd b
LDFLAGS=-lfftw3f_threads meson ..
ninja
cp libdfttest.so /usr/lib/vapoursynth/

git-shallow-clone "r10.1" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Yadifmod.git /src/VapourSynth-Yadifmod
pushd /src/VapourSynth-Yadifmod
./autogen.sh
./configure --prefix=/usr
make -j$(nproc)
cp .libs/libyadifmod.so /usr/lib/vapoursynth/

git-shallow-clone "2.40" https://github.com/FFMS/ffms2.git /src/ffms2
pushd /src/ffms2
./autogen.sh
./configure --prefix=/usr
make -j$(nproc)
make install


# AdddGrain
git-shallow-clone "master" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-AddGrain.git /src/VapourSynth-AddGrain
pushd /src/VapourSynth-AddGrain
meson build
ninja -C build
cp build/libaddgrain.so /usr/lib/vapoursynth/

# Bwdif
git-shallow-clone "master" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Bwdif.git /src/VapourSynth-Bwdif
pushd /src/VapourSynth-Bwdif
meson build
ninja -C build
cp build/libbwdif.so  /usr/lib/vapoursynth/

# CAS
git-shallow-clone "master" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-CAS.git /src/VapourSynth-CAS
pushd /src/VapourSynth-CAS
meson build
ninja -C build
cp build/libcas.so /usr/lib/vapoursynth/

# CTMF
git-shallow-clone "master" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-CTMF.git /src/VapourSynth-CTMF
pushd /src/VapourSynth-CTMF
meson build
ninja -C build
cp build/libctmf.so /usr/lib/vapoursynth/

# DCTFilter
git-shallow-clone "master" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DCTFilter.git /src/VapourSynth-DCTFilter
pushd /src/VapourSynth-DCTFilter
meson build
ninja -C build
cp build/libdctfilter.so /usr/lib/vapoursynth/

# Deblock
git-shallow-clone "master" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Deblock.git /src/VapourSynth-Deblock
pushd /src/VapourSynth-Deblock
meson build
ninja -C build
cp build/libdeblock.so /usr/lib/vapoursynth/

# EEDI2
git-shallow-clone "master" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI2.git /src/VapourSynth-EEDI2
pushd /src/VapourSynth-EEDI2
meson build
ninja -C build
cp build/libeedi2.so /usr/lib/vapoursynth/

# EEDI3
git-shallow-clone "master" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI3.git /src/VapourSynth-EEDI3
pushd /src/VapourSynth-EEDI3
meson build -Dopencl=false
ninja -C build
cp build/libeedi3m.so /usr/lib/vapoursynth/

# fluxsmooth
git-shallow-clone "master" https://github.com/dubhater/vapoursynth-fluxsmooth.git /src/vapoursynth-fluxsmooth
pushd /src/vapoursynth-fluxsmooth
./autogen.sh
./configure
make
cp .libs/libfluxsmooth.so /usr/lib/vapoursynth/

# hqdn3d
git-shallow-clone "master" https://github.com/Hinterwaeldlers/vapoursynth-hqdn3d.git /src/vapoursynth-hqdn3d
pushd /src/vapoursynth-hqdn3d
./autogen.sh
./configure
make
cp .libs/libhqdn3d.so /usr/lib/vapoursynth/

# KNLMeansCL
apt-get update && apt-get install -y ocl-icd-opencl-dev libopencl-clang-dev
git-shallow-clone "master" https://github.com/Khanattila/KNLMeansCL.git /src/KNLMeansCL
pushd /src/KNLMeansCL
meson build
ninja -C build
cp build/libknlmeanscl.so /usr/lib/vapoursynth/

# miscfilters (obsolete)
git-shallow-clone "master" https://github.com/vapoursynth/vs-miscfilters-obsolete.git /src/vs-miscfilters-obsolete
pushd /src/vs-miscfilters-obsolete
meson build
ninja -C build
cp build/libmiscfilters.so /usr/lib/vapoursynth/

# NNEDI3CL
git-shallow-clone "master" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-NNEDI3CL.git /src/VapourSynth-NNEDI3CL
pushd /src/VapourSynth-NNEDI3CL
meson build
ninja -C build
cp build/libnnedi3cl.so /usr/lib/vapoursynth/

# removegrain
git-shallow-clone "master" https://github.com/vapoursynth/vs-removegrain.git /src/vs-removegrain
pushd /src/vs-removegrain
meson build
ninja -C build
cp build/libremovegrain.so /usr/lib/vapoursynth/

# sangnom
# fork, original not on the net anymore
git-shallow-clone "master" https://github.com/dubhater/vapoursynth-sangnom.git /src/vapoursynth-sangnom
pushd /src/vapoursynth-sangnom
meson build
ninja -C build
cp build/libsangnom.so /usr/lib/vapoursynth/

# sangnom modded
git-shallow-clone "master" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-SangNomMod.git /src/VapourSynth-SangNomMod
pushd /src/VapourSynth-SangNomMod
./configure
make
cp ./libsangnommod.so /usr/lib/vapoursynth/

# TTempSmooth
git-shallow-clone "master" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-TTempSmooth.git /src/VapourSynth-TTempSmooth
pushd /src/VapourSynth-TTempSmooth
meson build
ninja -C build
cp build/libttempsmooth.so /usr/lib/vapoursynth/

# bestaudiosource
git-shallow-clone "master" https://github.com/vapoursynth/bestaudiosource.git /src/bestaudiosource
pushd /src/bestaudiosource
#curl https://raw.githubusercontent.com/vapoursynth/vapoursynth/master/include/VapourSynth4.h -O
meson build
ninja -C build
cp build/libbestaudiosource.so /usr/lib/vapoursynth/

# assrender
git-shallow-clone "master" https://github.com/AmusementClub/assrender.git /src/assrender
pushd /src/assrender
cmake -B build -S .
cmake --build build --clean-first
cp build/src/libassrender.so /usr/lib/vapoursynth/


curl https://raw.githubusercontent.com/HomeOfVapourSynthEvolution/havsfunc/3b6a80ce502e6775c70df6bb2d19124de149073f/havsfunc.py > /usr/lib/vapoursynth/havsfunc.py
curl https://raw.githubusercontent.com/HomeOfVapourSynthEvolution/mvsfunc/90e185220901402b974d7364345e0f25e71ab8fe/mvsfunc.py   > /usr/lib/vapoursynth/mvsfunc.py
curl https://raw.githubusercontent.com/Irrational-Encoding-Wizardry/fvsfunc/29ced90a3f620844dea0efa8666542298f68f421/fvsfunc.py > /usr/lib/vapoursynth/fvsfunc.py
curl https://raw.githubusercontent.com/WolframRhodium/muvsfunc/6158bf2af1cb85fd9ba44024c52ef3666a2834c1/muvsfunc.py > /usr/lib/vapoursynth/muvsfunc.py


sed -i 's/core\.nnedi3/core\.znedi3/' /usr/lib/vapoursynth/fvsfunc.py