#!/usr/bin/env bash
# AzerothCore NixOS Playerbots - One-shot install/update script

set -e

INSTALL_DIR="$HOME/Desktop/azerothcore-wotlk"
REBUILD=0

# Check for --clean flag
for arg in "$@"; do
  if [[ "$arg" == "--clean" ]]; then
    REBUILD=1
  fi
done

# Go to repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> Updating repository..."
git fetch origin Playerbot
git checkout Playerbot
git reset --hard origin/Playerbot

# Build inside nix-shell
echo "==> Entering nix-shell and building..."
nix-shell -p cmake ninja gcc openssl boost zlib bzip2 mariadb pkg-config readline clang --run "

if [[ $REBUILD -eq 1 || ! -d build ]]; then
  echo '==> Fresh build...'
  rm -rf build
  mkdir build
else
  echo '==> Incremental build...'
fi

cd build

cmake .. -G Ninja -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -DTOOLS_BUILD=all

echo '==> Compiling...'
ninja -j\$(nproc)

echo '==> Installing...'
ninja install
"

# Ensure logs folder exists
echo "==> Creating logs folder..."
mkdir -p "$INSTALL_DIR/logs/GM"

# Run client data setup
echo "==> Setting up client data (maps, vmaps, mmaps, dbc)..."
cd "$INSTALL_DIR"

if [[ -f "./acore.sh" ]]; then
  ./acore.sh client-data
else
  echo "WARNING: acore.sh not found. Skipping client data step."
fi

echo ""
echo "======================================="
echo "✅ DONE!"
echo "Server installed at: $INSTALL_DIR"
echo "Logs folder: $INSTALL_DIR/logs"
echo ""
echo "👉 Configure in authserver.conf & worldserver.conf:"
echo "LogsDir = $INSTALL_DIR/logs"
echo ""
echo "To update later:"
echo "  ./install_playerbot.sh"
echo ""
echo "To force full rebuild:"
echo "  ./install_playerbot.sh --clean"
echo "======================================="
