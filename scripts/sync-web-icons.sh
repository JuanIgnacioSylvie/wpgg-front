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

echo "Synced WPGG coin icons to web/"
