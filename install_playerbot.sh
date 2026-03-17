#!/usr/bin/env bash
set -e  # exit if any command fails

# One-shot build/install script for AzerothCore Playerbot branch on NixOS

# Set install path
INSTALL_DIR="$HOME/Desktop/azerothcore-wotlk"

echo "==> Removing old build folder (if exists)..."
rm -rf build
mkdir build
cd build

echo "==> Configuring CMake..."
cmake .. -G Ninja \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
  -DTOOLS_BUILD=all

echo "==> Building with Ninja..."
ninja -j$(nproc)

echo "==> Installing..."
ninja install

echo "==> Build and install complete!"
echo "Server installed to: $INSTALL_DIR"
