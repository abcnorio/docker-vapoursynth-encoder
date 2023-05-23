#!/bin/bash
set -e
set -o pipefail

git-shallow-clone "${RAV1E_TAG}" "${RAV1E_REPO}" /src/rav1e
pushd /src/rav1e
RUSTFLAGS="-C target-cpu=native" cargo build --release --features unstable,asm,threading

cp "$(cargo metadata --format-version 1 | jq -r '.target_directory')/release/rav1e" /usr/bin/rav1e