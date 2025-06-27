#!/bin/bash

set -e

# Clone libsodium if not already present
if [ ! -d "libsodium" ]; then
  git clone https://github.com/jedisct1/libsodium.git
fi

cd libsodium
git fetch
git checkout stable # or specify a version you want

# Clean previous build
rm -rf build
mkdir build && cd build

# Adjust these variables as needed for your project
INSTALL_PREFIX="${GITHUB_WORKSPACE:-$(pwd)/../../external/libsodium}"

cmake .. \
  -DCMAKE_SYSTEM_NAME=iOS \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}"

cmake --build . --target install

echo "libsodium built and installed to ${INSTALL_PREFIX}"