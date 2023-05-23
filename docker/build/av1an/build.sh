#!/bin/bash
set -e
set -o pipefail

source $HOME/.cargo/env

git-shallow-clone "${AV1AN_TAG}" "${AV1AN_REPO}" /src/av1an
pushd /src/av1an
CFLAGS="" CXXFLAGS="" CPPFLAGS="" LDFLAGS="" LD=ld RUSTFLAGS="-C target-cpu=native" cargo build --release --features ""

cp "$(cargo metadata --format-version 1 | jq -r '.target_directory')/release/av1an" /usr/bin/av1an