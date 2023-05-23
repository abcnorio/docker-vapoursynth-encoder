#!/bin/bash

mkdir -p "${3}"
pushd "${3}" || exit 1
git init
git remote add origin "${2}"
git fetch --progress --jobs $(nproc) --depth 1 origin "${1}"
git checkout FETCH_HEAD
git submodule update --jobs $(nproc) --depth 1 --init