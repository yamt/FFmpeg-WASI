#!/bin/bash

set -euo pipefail

cd deps/x264
CC=../../wasi-sdk/bin/clang \
    AR=../../wasi-sdk/bin/ar \
    RANLIB=../../wasi-sdk/bin/ranlib \
    ./configure \
    --prefix=../../build \
    --host=i686-gnu \
    --enable-static \
    --disable-cli \
    --disable-asm \
    --extra-cflags="-pthread -target wasm32-wasi-threads -D_WASI_EMULATED_SIGNAL" \
    --extra-ldflags="-lc -lwasi-emulated-signal"
sed -i 's/#define HAVE_MALLOC_H 1/#define HAVE_MALLOC_H 0/g' config.h
make install-lib-static
cd ../..
