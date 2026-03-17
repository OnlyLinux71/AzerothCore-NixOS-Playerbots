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
ACORE_SCRIPT="$SCRIPT_DIR/acore.sh"
if [[ -f "$ACORE_SCRIPT" ]]; then
  "$ACORE_SCRIPT" client-data

  # Move extracted data to install folder
  DATA_SRC="$SCRIPT_DIR/env/dist/bin/data"
  DATA_DEST="$INSTALL_DIR/data"
  if [[ -d "$DATA_SRC" ]]; then
    mkdir -p "$DATA_DEST"
    echo "==> Moving client data to $DATA_DEST..."
    mv "$DATA_SRC"/* "$DATA_DEST/"
  else
    echo "WARNING: Client data not found at $DATA_SRC. Check acore.sh output."
  fi

  # Generate maps, vmaps, mmaps
  echo "==> Generating maps, vmaps, mmaps..."
  cd "$INSTALL_DIR"
  if [[ -f "$INSTALL_DIR/tools/map_extractor/map_extractor" ]]; then
    ./tools/map_extractor/map_extractor
  fi
  if [[ -f "$INSTALL_DIR/tools/vmap4_extractor/vmap4_extractor" ]]; then
    ./tools/vmap4_extractor/vmap4_extractor Buildings vmaps
  fi
  if [[ -f "$INSTALL_DIR/tools/vmap4_assembler/vmap4_assembler" ]]; then
    ./tools/vmap4_assembler/vmap4_assembler
  fi
  if [[ -f "$INSTALL_DIR/tools/mmaps_generator/mmaps_generator" ]]; then
    ./tools/mmaps_generator/mmaps_generator
  fi

else
  echo "WARNING: acore.sh not found in repo root. Skipping client data step."
fi

echo ""
echo "======================================="
echo "✅ DONE!"
echo "Server installed at: $INSTALL_DIR"
echo "Logs folder: $INSTALL_DIR/logs"
echo "Data folder: $INSTALL_DIR/data"
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
