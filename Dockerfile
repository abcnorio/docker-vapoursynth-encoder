FROM debian:bullseye AS dep-base

ENV PYTHON_VERSION=3.9

RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    libpython${PYTHON_VERSION} python3-pip python3-numpy python3-opencv python3-tk git nscd curl xz-utils ca-certificates gpg gnupg \
    libavcodec58 libavformat58 libswscale5 libavresample4 libavutil56 libavfilter7 libavdevice58 libass9 \
    libnuma1 libatomic1 libfftw3-3 && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install Cython

FROM dep-base AS build-base

COPY docker/clang.list /etc/apt/sources.list.d/clang.list

RUN curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    python${PYTHON_VERSION}-dev \
    python3-setuptools python3-wheel \
    autoconf automake libtool pkg-config meson ninja-build make rake cmake yasm nasm gcc g++ clang llvm lld ccache jq \
    libflac-dev libogg-dev libvorbis-dev libboost-all-dev zlib1g-dev libdvdread-dev libgmp-dev xsltproc docbook-xsl doxygen \
    libxcb-xinerama0-dev \
    libnuma-dev libavcodec-dev libavformat-dev libswscale-dev libavresample-dev libavutil-dev libavfilter-dev libavdevice-dev libass-dev libfftw3-3 libfftw3-dev && \
    update-alternatives --install /usr/bin/cc cc $(readlink -f /usr/bin/clang) 100 && \
    update-alternatives --install /usr/bin/c++ c++ $(readlink -f /usr/bin/clang++) 100 && \
    update-alternatives --install /usr/bin/link link $(readlink -f /usr/bin/ld.lld) 100

ENV CC=clang
ENV CXX=clang++
ENV LD=ld.lld
ENV CFLAGS "-Ofast -march=native -flto"
ENV CPPFLAGS "$CFLAGS"
ENV CXXFLAGS "-Ofast -march=native -flto"
ENV LDFLAGS "-flto -fuse-ld=lld"

COPY docker/git-shallow-clone.sh /usr/bin/git-shallow-clone


FROM build-base AS build-x265

ARG X265_TAG=3.5
ARG X265_REPO=https://bitbucket.org/multicoreware/x265_git.git

COPY docker/build/x265/multilib.sh /multilib.sh
COPY docker/build/x265/build.sh /build.sh

RUN /build.sh


FROM build-base AS build-lsmash

COPY docker/build/l-smash/build.sh /build-l-smash.sh

RUN /build-l-smash.sh

FROM build-lsmash AS build-x264

ARG X264_REPO=https://code.videolan.org/videolan/x264.git

COPY docker/build/x264/build.sh /build.sh

RUN /build.sh stable

FROM build-lsmash AS build-x264-dev

ARG X264_REPO=https://code.videolan.org/videolan/x264.git

COPY docker/build/x264/build.sh /build.sh

RUN /build.sh master

FROM build-base AS build-uvg266

ARG UVG266_DEFS=""
ARG UVG266_TAG=v0.4.0
ARG UVG266_REPO=https://github.com/ultravideo/uvg266.git

COPY docker/build/uvg266/build.sh /build.sh

RUN /build.sh

FROM build-base AS build-uvg266-10bit

ARG UVG266_DEFS="-DUVG_BIT_DEPTH=10"
ARG UVG266_TAG=v0.4.0
ARG UVG266_REPO=https://github.com/ultravideo/uvg266.git

COPY docker/build/uvg266/build.sh /build.sh

RUN /build.sh

FROM build-base AS build-vvenc

ARG VVENC_TAG=9314837004a86900c5c02d76571f51a2d227f2bb
ARG VVENC_REPO=https://github.com/fraunhoferhhi/vvenc.git

COPY docker/build/vvenc/build.sh /build.sh

RUN /build.sh

FROM build-base AS build-aom

ARG AOM_TAG=v3.4.0
ARG AOM_REPO=https://aomedia.googlesource.com/aom.git

ARG VMAF_TAG=v2.3.1
ARG VMAF_REPO=https://github.com/Netflix/vmaf.git

ARG BROTLI_TAG=v1.0.9
ARG BROTLI_REPO=https://github.com/google/brotli.git

ARG JXL_TAG=v0.6.1
ARG JXL_REPO=https://github.com/libjxl/libjxl.git

COPY docker/build/vmaf/build.sh /build-vmaf.sh
#COPY docker/build/jxl/build.sh /build-jxl.sh
#COPY docker/build/brotli/build.sh /build-brotli.sh
COPY docker/build/aom/build.sh /build.sh

RUN /build-vmaf.sh
#RUN /build-brotli.sh
#RUN /build-jxl.sh
RUN /build.sh

FROM build-base AS build-svt-av1

ARG SVT_TAG=v1.1.0
ARG SVT_REPO=https://gitlab.com/AOMediaCodec/SVT-AV1.git

COPY docker/build/svt-av1/build.sh /build.sh

RUN /build.sh

FROM rust:1.62-bullseye AS build-rav1e

ARG RAV1E_TAG=p20220614
ARG RAV1E_REPO=https://github.com/xiph/rav1e.git

RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    nasm jq

COPY docker/git-shallow-clone.sh /usr/bin/git-shallow-clone
COPY docker/build/rav1e/build.sh /build.sh

RUN /build.sh

FROM build-base AS build-fdk-aac

ARG FDKAAC_TAG=master
ARG FDKAAC_REPO=https://github.com/mstorsjo/fdk-aac.git

COPY docker/build/fdk-aac/build.sh /build.sh

RUN /build.sh

FROM build-lsmash AS build-vapoursynth

ARG MAGICK_TAG=7.1.0-39
ARG ZIMG_TAG=release-3.0.4
ARG VS_TAG=R55

COPY docker/build/magick/build.sh /build-magick.sh
COPY docker/build/zimg/build.sh /build-zimg.sh
COPY docker/build/vapoursynth/build.sh /build-vapoursynth.sh


RUN /build-zimg.sh && \
    /build-magick.sh && \
    /build-vapoursynth.sh

ENV PYTHONPATH "/usr/lib/python${PYTHON_VERSION}/site-packages:/usr/lib/vapoursynth:$PYTHONPATH"

# additional plugins for R55 (havsfunc, BAS, assrender, ...)
COPY docker/build/vapoursynth-plugins/build.sh /build-vapoursynth-plugins.sh

RUN  /build-vapoursynth-plugins.sh

FROM build-base AS build-mkvtoolnix

RUN echo "deb-src http://deb.debian.org/debian bullseye main" > /etc/apt/sources.list.d/src.list && \
    echo "deb-src http://security.debian.org/debian-security bullseye-security main" >> /etc/apt/sources.list.d/src.list && \
    echo "deb-src http://deb.debian.org/debian bullseye-updates main" >> /etc/apt/sources.list.d/src.list && \
    DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt build-dep -y qtbase-opensource-src

ARG MKVTOOLNIX_TAG=release-68.0.0
ARG MKVTOOLNIX_REPO=https://gitlab.com/mbunkus/mkvtoolnix.git

COPY docker/build/qt5/build.sh /build-qt5.sh
COPY docker/build/mkvtoolnix/build.sh /build.sh

RUN /build-qt5.sh
RUN /build.sh



FROM build-vapoursynth AS build-av1an

ARG AV1AN_TAG=a5f69398245436b8c0c49f07bec8ca32cf5df75e
ARG AV1AN_REPO=https://git.gammaspectra.live/WeebDataHoarder/Av1an.git

ARG VMAF_TAG=v2.3.1
ARG VMAF_REPO=https://github.com/Netflix/vmaf.git

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

COPY docker/build/vmaf/build.sh /build-vmaf.sh
COPY docker/build/av1an/build.sh /build-av1an.sh

RUN /build-vmaf.sh
RUN /build-av1an.sh

FROM build-base AS build-xeve

ARG XEVE_TAG=v0.4.0
ARG XEVE_REPO=https://github.com/mpeg5/xeve.git

COPY docker/build/xeve/build.sh /build.sh

RUN /build.sh BASE

FROM build-base AS build-xeve-main

ARG XEVE_TAG=v0.4.0
ARG XEVE_REPO=https://github.com/mpeg5/xeve.git

COPY docker/build/xeve/build.sh /build.sh

RUN /build.sh MAIN

FROM build-base AS build-mediainfo

ARG ZENLIB_TAG=v0.4.39
ARG MEDIAINFO_TAG=v22.06
ARG MEDIAINFOLIB_TAG=v22.06

COPY docker/build/mediainfo/build.sh /build.sh

RUN /build.sh

FROM dep-base

RUN pip3 install git+https://github.com/FichteFoll/Sushi.git@master

RUN curl "https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-$(dpkg --print-architecture)-static.tar.xz" > /tmp/ffmpeg.tar.xz && \
    cd /tmp && tar -xJf /tmp/ffmpeg.tar.xz && cd ffmpeg-* && \
    cp -r model /usr/local/share/ && \
    cp ./ffprobe /usr/bin/ && \
    cp ./ffmpeg /usr/bin/ && \
    cp ./qt-faststart /usr/bin/ && \
    cd / && rm -r /tmp/ffmpeg*


ENV PYTHONPATH "/usr/lib/python${PYTHON_VERSION}/site-packages:/usr/lib/vapoursynth:$PYTHONPATH"

COPY --from=build-x265 /usr/bin/x265 /usr/bin/x265

COPY --from=build-x264 /usr/bin/x264 /usr/bin/x264
COPY --from=build-x264-dev /usr/bin/x264 /usr/bin/x264-dev

COPY --from=build-aom /usr/bin/aom* /usr/bin/
COPY --from=build-svt-av1 /usr/bin/SvtAv1* /usr/bin/
COPY --from=build-rav1e /usr/bin/rav1e /usr/bin/rav1e
COPY --from=build-av1an /usr/bin/av1an /usr/bin/av1an
COPY --from=build-av1an /usr/bin/vmaf /usr/bin/vmaf

COPY --from=build-uvg266 /usr/bin/uvg266 /usr/bin/uvg266
COPY --from=build-uvg266-10bit /usr/bin/uvg266 /usr/bin/uvg266-10bit
COPY --from=build-vvenc /usr/bin/vvenc* /usr/bin/

COPY --from=build-xeve /usr/bin/xeveb_app /usr/bin/xeveb
COPY --from=build-xeve-main /usr/bin/xeve_app /usr/bin/xeve

COPY --from=build-fdk-aac /usr/bin/aac-enc /usr/bin/aac-enc

COPY --from=build-vapoursynth /usr/bin/vspipe /usr/bin/vspipe
COPY --from=build-vapoursynth /usr/lib/python${PYTHON_VERSION}/site-packages/vapoursynth.* /usr/lib/python${PYTHON_VERSION}/site-packages/
COPY --from=build-vapoursynth /usr/lib/libvapoursynth* /usr/lib/
COPY --from=build-vapoursynth /usr/lib/libzimg* /usr/lib/
COPY --from=build-vapoursynth /usr/lib/vapoursynth /usr/lib/vapoursynth
COPY --from=build-vapoursynth /usr/lib/libvs* /usr/lib/
COPY --from=build-vapoursynth /usr/lib/libffms* /usr/lib/

COPY --from=build-vapoursynth /usr/bin/magick /usr/bin/magick
COPY --from=build-vapoursynth /usr/etc/ImageMagick-7 /usr/etc/ImageMagick-7

COPY --from=build-mkvtoolnix /usr/bin/mkv* /usr/bin/
COPY --from=build-mediainfo /usr/bin/mediainfo /usr/bin/mediainfo