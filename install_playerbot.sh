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
if [[ \$REBUILD -eq 1 || ! -d build ]]; then
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
REPO_ROOT="$SCRIPT_DIR"

if [[ -f "$REPO_ROOT/acore.sh" ]]; then
  # Run acore.sh from repo root
  "$REPO_ROOT/acore.sh" client-data

  # Move extracted data to proper folders
  mkdir -p "$INSTALL_DIR/data/maps" "$INSTALL_DIR/data/vmaps" "$INSTALL_DIR/data/mmaps" "$INSTALL_DIR/data/dbc"

  mv "$REPO_ROOT/env/dist/bin/data/maps/"* "$INSTALL_DIR/data/maps/" 2>/dev/null || true
  mv "$REPO_ROOT/env/dist/bin/data/vmaps/"* "$INSTALL_DIR/data/vmaps/" 2>/dev/null || true
  mv "$REPO_ROOT/env/dist/bin/data/mmaps/"* "$INSTALL_DIR/data/mmaps/" 2>/dev/null || true
  mv "$REPO_ROOT/env/dist/bin/data/dbc/"* "$INSTALL_DIR/data/dbc/" 2>/dev/null || true

  # Generate maps, vmaps, mmaps
  echo "==> Generating maps, vmaps, mmaps..."
  cd "$INSTALL_DIR"
  [[ -f "$INSTALL_DIR/tools/map_extractor/map_extractor" ]] && ./tools/map_extractor/map_extractor
  [[ -f "$INSTALL_DIR/tools/vmap4_extractor/vmap4_extractor" ]] && ./tools/vmap4_extractor/vmap4_extractor Buildings vmaps
  [[ -f "$INSTALL_DIR/tools/vmap4_assembler/vmap4_assembler" ]] && ./tools/vmap4_assembler/vmap4_assembler
  [[ -f "$INSTALL_DIR/tools/mmaps_generator/mmaps_generator" ]] && ./tools/mmaps_generator/mmaps_generator

else
  echo "WARNING: acore.sh not found in repository root. Skipping client data step."
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
