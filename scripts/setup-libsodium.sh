#!/bin/bash
set -e

# Create external/libsodium directories if not exists
mkdir -p external/libsodium/include
mkdir -p external/libsodium/lib

# Install libsodium via Homebrew
brew install libsodium

LIBSODIUM_PREFIX=$(brew --prefix libsodium)

# Copy headers and libs to expected locations
cp -R $LIBSODIUM_PREFIX/include/* external/libsodium/include/
cp -R $LIBSODIUM_PREFIX/lib/* external/libsodium/lib/