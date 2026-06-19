#!/usr/bin/env bash
# Copy WPGG coin assets into web/ favicon + PWA icons (source of truth: assets/images/wpgg-coin_*).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ASSETS="$ROOT/assets/images"
WEB="$ROOT/web"

cp "$ASSETS/wpgg-coin_16x16.png" "$WEB/icons/icon-16.png"
cp "$ASSETS/wpgg-coin_24x24.png" "$WEB/icons/icon-24.png"
cp "$ASSETS/wpgg-coin_32x32.png" "$WEB/icons/icon-32.png"
cp "$ASSETS/wpgg-coin_32x32.png" "$WEB/favicon.png"
cp "$ASSETS/wpgg-coin_180x180.png" "$WEB/icons/apple-touch-icon.png"
cp "$ASSETS/wpgg-coin_192x192.png" "$WEB/icons/Icon-192.png"
cp "$ASSETS/wpgg-coin_192x192.png" "$WEB/icons/Icon-maskable-192.png"
cp "$ASSETS/wpgg-coin_512x512.png" "$WEB/icons/Icon-512.png"
cp "$ASSETS/wpgg-coin_512x512.png" "$WEB/icons/Icon-maskable-512.png"

# Google favicon: 48×48 PNG (multiple of 48). favicon.ico is the same PNG — Google's ICO
# decoder corrupts PNG-in-ICO containers from to-ico/png-to-ico.
if command -v magick >/dev/null 2>&1; then
  magick "$ASSETS/wpgg-coin_192x192.png" -resize 48x48 "$WEB/icons/icon-48.png"
  cp "$WEB/icons/icon-48.png" "$WEB/favicon.ico"
elif command -v node >/dev/null 2>&1; then
  if ! node -e "require('sharp')" >/dev/null 2>&1; then
    npm install --no-save sharp --prefix "$ROOT"
  fi
  node "$ROOT/scripts/generate-favicon-ico.mjs"
else
  cp "$ASSETS/wpgg-coin_32x32.png" "$WEB/icons/icon-48.png"
  cp "$WEB/icons/icon-48.png" "$WEB/favicon.ico"
fi

echo "Synced WPGG coin icons to web/"
