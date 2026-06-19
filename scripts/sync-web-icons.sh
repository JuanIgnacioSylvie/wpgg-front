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

# Browsers and Google request /favicon.ico. Must be a real ICO (not a renamed PNG) and a
# static file — the SPA rewrite must not serve index.html for this path.
if command -v magick >/dev/null 2>&1; then
  magick "$ASSETS/wpgg-coin_32x32.png" -define icon:auto-resize=16,32,48 "$WEB/favicon.ico"
elif command -v convert >/dev/null 2>&1; then
  convert "$ASSETS/wpgg-coin_32x32.png" -define icon:auto-resize=16,32,48 "$WEB/favicon.ico"
elif command -v node >/dev/null 2>&1; then
  if ! node -e "require('to-ico')" >/dev/null 2>&1; then
    npm install --no-save to-ico --prefix "$ROOT"
  fi
  node "$ROOT/scripts/generate-favicon-ico.mjs"
else
  echo "ERROR: need ImageMagick or Node.js to build favicon.ico" >&2
  exit 1
fi

echo "Synced WPGG coin icons to web/"
