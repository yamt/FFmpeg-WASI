#!/bin/bash

set -euo pipefail

FFMPEG_CONFIG_FLAGS_BASE=(
  --target-os=none        # use none to prevent any os specific configurations
  --arch=x86_32           # use x86_32 to achieve minimal architectural optimization
  --enable-cross-compile  # enable cross compile
  --disable-x86asm        # disable x86 asm
  --disable-inline-asm    # disable inline asm
  --disable-stripping     # disable stripping
  --disable-doc           # disable doc
  --disable-debug         # disable debug info, required by closure
  --disable-runtime-cpudetect   # disable runtime cpu detect
  --disable-autodetect    # disable external libraries auto detect
  --disable-network       # https://github.com/WebAssembly/wasi-sdk/issues/112
  --enable-pthreads
  --disable-w32threads
  --disable-os2threads
  --pkg-config-flags="--static"
  --enable-lto            # use link-time optimization

  --nm=../wasi-sdk/bin/nm
  --ar=../wasi-sdk/bin/ar
  --ranlib=../wasi-sdk/bin/ranlib
  --cc=../wasi-sdk/bin/clang
  --cxx=../wasi-sdk/bin/clang++
  --objcc=../wasi-sdk/bin/clang
  --dep-cc=../wasi-sdk/bin/clang

  --enable-gpl
  --enable-libx264
  --enable-zlib

#  --extra-cflags="-I../build/include"
#  --extra-ldflags="-L../build/lib"
)

mkdir -p build

cd FFmpeg
MAX_MEMORY=131072000
./configure ${FFMPEG_CONFIG_FLAGS_BASE[@]} \
--extra-cflags="-pthread -target wasm32-wasi-threads -ftls-model=local-exec -I../build/include" \
--extra-ldflags="-pthread -target wasm32-wasi-threads -Wl,--max-memory=${MAX_MEMORY} -Wl,--import-memory -Wl,--export-memory -L../build/lib"

make -n |
  sed 's/clang /clang -D_WASI_EMULATED_PROCESS_CLOCKS -lwasi-emulated-process-clocks /g' |
  sed 's/clang /clang -D_WASI_EMULATED_SIGNAL -lwasi-emulated-signal /g' |
  cat > ../build/compile.sh
chmod +x ../build/compile.sh
cd ..
