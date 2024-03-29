# Docker env (VapourSynth, plugins, encoders)

This is a fork of [WeebDataHoarder](https://git.gammaspectra.live/WeebDataHoarder/encoder). It extends the original Dockerfile to R55 (VapourSynth) and adds some more VapourSynth plugins.
It is useful to create a docker container to run VapourSynth headless on a server remotely (batch mode, ...).
Besides VapourSynth, the Dockerfile features several video encoding / processing / filtering utilities.

## Build and run
```bash
docker build -t encoder .
docker run -it --rm -v /path/to/mount/on/container:/mnt encoder
```

## Usage

```bash
# define $output and $output-av-mux files initially
output=/path/and/filename/of-temporary-audio-video-file-without-file-ending
output-av-mux="$output"-av-mux

# vspipe/ vapoursynth cannot output a + v at the same time
# encode separately and then mux

# video with output mp4
vspipe vapoursynth-config.vpy | vspipe -o 0 -c y4m "vapoursynth-config.vpy" - | ffmpeg -nostdin -i - -c:v libx264 "$output.mp4"

# audio with output aac
vspipe $vapoursynth-config.vpy
vspipe -o 1 -c wav "vapoursynth-config.vpy" - | ffmpeg -nostdin -i - -c:a aac "$output.aac"

# av mux
ffmpeg -nostdin -i "$output.mp4" -i "$output.aac" -c:v copy -c:a copy -disposition:a:1 default "$output-av-mux.mp4"
```

# Example VapourSynth config file
vapoursynth-config.vpy (example: wav audio + vob video + deinterlacing with QTGMC + subtitles with assrender)
```
import vapoursynth as vs
import sys

# path to folder with havsfunc.py
sys.path.append('/path/to/folder-with-havsfunc.py')
import havsfunc

core = vs.core

haf = havsfunc

# input wav file
audio = core.bas.Source('inputfile.wav', track=-1)

# input video file - here d2v file for vob files
video = core.d2v.Source(input=r'inputfile.d2v')
# do deinterlacing with QTGMC
video = haf.QTGMC(video, Preset='Slow', TFF=True)
# add subtitles in ass format
video = core.assrender.TextSub(clip=video, file=r'subtitlefile.ass')

# set output
audio.set_output(index=1)
video.set_output(index=0) 
```

## Included tools

| Tool | Kind | Notes |
| --- | --- | --- |
| [ffmpeg](https://johnvansickle.com/ffmpeg/) | General Tools | static build from git snapshot. Can be accessed via `$ ffmpeg` |
| [Sushi](https://github.com/FichteFoll/Sushi) | Subtitle Syncing | Automatic shifter for SRT and ASS subtitle based on audio streams. Can be accessed via `$ sushi` |
| [MKVToolNix 68.0.0](https://gitlab.com/mbunkus/mkvtoolnix/-/tree/release-68.0.0) | Matroska Tools | Creating and working with Matroska files. |
| [MediaInfo v22.06](https://github.com/MediaArea/MediaInfo/tree/v22.06) | General Tools | Convenient unified display of the most relevant technical and tag data for video and audio files. |
| [x264 stable](https://code.videolan.org/videolan/x264/-/tree/stable) | H.264 Encoder | x264, the best and fastest H.264 encoder. Can be accessed via `$ x264` |
| [x264 master](https://code.videolan.org/videolan/x264/-/tree/master) | H.264 Encoder | Can be accessed via `$ x264-dev` |
| [x265 3.5](https://bitbucket.org/multicoreware/x265_git/src/3.5/) | H.265/HEVC Encoder | |
| [aom v3.4.0](https://aomedia.googlesource.com/aom/+/refs/tags/v3.4.0/) | AV1 Encoder/Decoder | Can be accessed via `$ aomenc` or `$ aomdec` |
| [SVT-AV1 v1.1.0](https://gitlab.com/AOMediaCodec/SVT-AV1/-/releases/v1.1.0) | AV1 Encoder/Decoder | Can be accessed via `$ SvtAv1EncApp` or `$ SvtAv1DecApp` |
| [rav1e p20220614](https://github.com/xiph/rav1e/tree/p20220614) | AV1 Encoder | Can be accessed via `$ rav1e` |
| [uvg266 v0.4.0](https://github.com/ultravideo/uvg266/tree/v0.4.0) | H.266/VVC Encoder | Can be accessed via `$ uvg266` or `$ uvg266-10bit` |
| [vvenc v1.4.0](https://github.com/fraunhoferhhi/vvenc/tree/v1.4.0) | H.266/VVC Encoder | Fraunhofer Versatile Video Encoder (VVenC). Can be accessed via `$ vvencapp` or `$ vvencFFapp` |
| [xeve v0.3.4](https://github.com/mpeg5/xeve/tree/v0.4.0) | MPEG-5 EVC Encoder | eXtra-fast Essential Video Encoder, MPEG-5 EVC (Essential Video Coding). Can be accessed via `$ xeveb` or `$ xeve` |
| [FDK-AAC master](https://github.com/mstorsjo/fdk-aac) | AAC-LC/HE/HEv2 Encoder | Fraunhofer FDK AAC code from Android. Can be accessed via `$ aac-enc` |
| [Av1an fork](https://git.gammaspectra.live/WeebDataHoarder/Av1an) | Encoding Tools | Cross-platform command-line AV1 / VP9 / HEVC / H264 encoding framework with per scene quality encoding. Can be accessed via `$ av1an`.<br/>Contains custom changes to add distributed encoding. |
| [vmaf v2.3.1](https://github.com/Netflix/vmaf/tree/v2.3.1) | Processing Tools | Perceptual video quality assessment based on multi-method fusion. Can be accessed via `$ vmaf` |
| [VapourSynth R55](https://github.com/vapoursynth/vapoursynth.git) | Processing Tools | Can be accessed via `$ vspipe` |
| [L-SMASH-Works](https://github.com/VFR-maniac/L-SMASH-Works) | VapourSynth Plugin | |
| [d2vsource v1.2](https://github.com/dwbuiten/d2vsource/tree/v1.2) | VapourSynth Plugin | D2V parser and decoder for VapourSynth |
| [VapourSynth-TDeintMod r10.1](https://github.com/HomeOfVapourSynthEvolution/VapourSynth-TDeintMod/tree/r10.1) | VapourSynth Plugin | TDeint filter for VapourSynth |
| [fmtconv r28](https://github.com/EleonoreMizo/fmtconv/tree/r28) | VapourSynth Plugin | Format conversion tools for Vapoursynth and Avisynth+ |
| [vapoursynth-mvtools](https://github.com/dubhater/vapoursynth-mvtools/tree/v23) | VapourSynth Plugin | Motion compensation and stuff |
| [VapourSynth-FFT3DFilter 64323f0](https://github.com/myrsloik/VapourSynth-FFT3DFilter/tree/64323f0fdee4dd4fe429ee6287906dbae8e7571c) | VapourSynth Plugin | VapourSynth port of FFT3DFilter |
| [znedi3 r2.1](https://github.com/sekrit-twc/znedi3/tree/r2.1) | VapourSynth Plugin | nnedi3 filter |
| [descale r7](https://github.com/Irrational-Encoding-Wizardry/descale/tree/r7) | VapourSynth Plugin | VapourSynth plugin to undo upscaling |
| [flash3kyuu_deband](https://github.com/SAPikachu/flash3kyuu_deband) | VapourSynth Plugin | A deband library and filter for avisynth/vapoursynth |
| [VapourSynth-BM3D r9](https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D/tree/r9) | VapourSynth Plugin | BM3D denoising filter for VapourSynth |
| [VapourSynth-DFTTest r7](https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DFTTest/tree/r7) | VapourSynth Plugin | DFTTest filter for VapourSynth |
| [VapourSynth-Yadifmod r10.1](https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Yadifmod/tree/r10.1) | VapourSynth Plugin | Yadifmod filter for VapourSynth |
| [ffms2 2.40](https://github.com/FFMS/ffms2/tree/2.40) | VapourSynth Plugin | An FFmpeg based source library and Avisynth/VapourSynth plugin for easy frame accurate access |
| [havsfunc 3b6a80](https://github.com/HomeOfVapourSynthEvolution/havsfunc) | VapourSynth Functions | Holy's ported AviSynth functions for VapourSynth |
| [mvsfunc 90e185](https://github.com/HomeOfVapourSynthEvolution/mvsfunc) | VapourSynth Functions | mawen1250's VapourSynth functions |
| [fvsfunc 29ced9](https://github.com/Irrational-Encoding-Wizardry/fvsfunc) | VapourSynth Functions | Small collection of VapourSynth functions |
| [muvsfunc 6158bf](https://github.com/WolframRhodium/muvsfunc) | VapourSynth Functions | Muonium's VapourSynth functions |
| [AddGrain](https://github.com/HomeOfVapourSynthEvolution/VapourSynth-AddGrain) | VapourSynth Plugin | adding random noise to film |
| [Bwdif](https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Bwdif) | VapourSynth Plugin | Motion adaptive deinterlacing using yadif/ w3fdif/ cubic interpolation |
| [CAS](https://github.com/HomeOfVapourSynthEvolution/VapourSynth-CAS) | VapourSynth Plugin | contrast adaptive sharpening |
| [CTMF](https://github.com/HomeOfVapourSynthEvolution/VapourSynth-CTMF) | VapourSynth Plugin | Constant-time median filtering |
| [DCTFilter](https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DCTFilter) | VapourSynth Plugin | 8x8 block/ Discrete Cosine Transform |
| [Deblock](https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Deblock) | VapourSynth Plugin | deblocking filter of h264 |
| [EEDI2](https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI2) | VapourSynth Plugin | resizes/ edge-directed interpolation for deinterlacing |
| [EEDI3](https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI3) | VapourSynth Plugin | de-interlacing by minimizing a cost function |
| [fluxsmooth](https://github.com/dubhater/vapoursynth-fluxsmooth) | VapourSynth Plugin | smoothing of fluctuations |
| [hqdn3d](https://github.com/Hinterwaeldlers/vapoursynth-hqdn3d) | VapourSynth Plugin | 3-way low-pass filter |
| [KNLMeansCL](https://github.com/Khanattila/KNLMeansCL) | VapourSynth Plugin | non-local means denoising |
| [miscfilters](https://github.com/vapoursynth/vs-miscfilters-obsolete) | VapourSynth Plugin | various filters (obsolete?) |
| [NNEDI3CL](https://github.com/HomeOfVapourSynthEvolution/VapourSynth-NNEDI3CL) | VapourSynth Plugin | intra-field only deinterlacer |
| [removegrain](https://github.com/vapoursynth/vs-removegrain) | VapourSynth Plugin | remove grain |
| [sangnom](https://github.com/dubhater/vapoursynth-sangnom) | VapourSynth Plugin | single field de-interlacer using edge-directed interpolation |
| [sangnom modded](https://github.com/HomeOfVapourSynthEvolution/VapourSynth-SangNomMod) | VapourSynth Plugin | de-interlacing/ luma/chroma anti-aliasing|
| [TTempSmooth](https://github.com/HomeOfVapourSynthEvolution/VapourSynth-TTempSmooth) | VapourSynth Plugin | motion adaptive temporal smoothing |
| [bestaudiosource](https://github.com/vapoursynth/bestaudiosource) | VapourSynth Plugin | allow audio usage within VapourSynth |
| [assrender](https://github.com/AmusementClub/assrender) | VapourSynth Plugin | insert subtitles of ssa/ass/srt type |

The two patch files contain the changes compared to [WeebDataHoarder](https://git.gammaspectra.live/WeebDataHoarder/encoder)'s original repo:
- `Dockerfile.patch`
- `vps-plugins_build-sh.patch`
