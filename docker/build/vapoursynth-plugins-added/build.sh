#!/bin/bash
set -e
set -o pipefail

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

# the following was already present on weebdatahoarder/encoder

# !! already present !!
# BM3D
#git-shallow-clone "master" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D.git /src/VapourSynth-BM3D
#pushd /src/VapourSynth-BM3D
#meson build
#ninja -C build
#cp build/libbm3d.so /usr/lib/vapoursynth/

# DFTTest
#git-shallow-clone "master" https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DFTTest.git /src/VapourSynth-DFTTest
#pushd /src/VapourSynth-DFTTest
#meson build
#ninja -C build
#cp build/libdfttest.so /usr/lib/vapoursynth/

# FFT3DFilter
#git-shallow-clone "master" https://github.com/myrsloik/VapourSynth-FFT3DFilter.git /src/VapourSynth-FFT3DFilter
#pushd /src/VapourSynth-FFT3DFilter
#meson build
#ninja -C build
#cp build/libfft3dfilter.so /usr/lib/vapoursynth/

# mvtools
#git-shallow-clone "master" https://github.com/dubhater/vapoursynth-mvtools.git /src/vapoursynth-mvtools
#pushd /src/vapoursynth-mvtools
#meson build
#ninja -C build
#cp .libs/libmvtools.so /usr/lib/vapoursynth/

# znedi3
#git-shallow-clone "master" https://github.com/sekrit-twc/znedi3.git /src/znedi3
#pushd /src/znedi3
#meson build
#ninja -C build
#cp build/vsznedi3.so /usr/lib/vapoursynth/

# svp4
#apt-get install -y wget bzip2
#mkdir -p /src/svp4
#wget https://www.svp-team.com/files/svp4-latest.php?linux -O /src/svp4/svp4-linux.4.5.210-1.tar.bz2
#pushd /src/svp4
#tar -xvjf ./svp4-linux.4.5.210-1.tar.bz2 
#chmod +x ./svp4-linux-64.run
#./svp4-linux-64.run
