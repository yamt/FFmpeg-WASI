#!/bin/bash

set -euo pipefail

WASI_VERSION=17
WASI_VERSION_FULL=${WASI_VERSION}.7gafa685ef7a50
wget https://github.com/yamt/wasi-sdk/releases/download/yamt-20221229/wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz
tar xvf wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz
rm wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz
mv wasi-sdk-${WASI_VERSION_FULL} wasi-sdk
