#!/usr/bin/env bash
# Vercel build: generate firebase-config.js, compile Flutter web, output build/web.
# Set these in Vercel → Settings → Environment Variables (Production):
#   WPGG_FIREBASE_API_KEY, WPGG_FIREBASE_VAPID_KEY, WPGG_BASE_URL (optional)

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

: "${WPGG_FIREBASE_API_KEY:?WPGG_FIREBASE_API_KEY is required}"
: "${WPGG_FIREBASE_VAPID_KEY:?WPGG_FIREBASE_VAPID_KEY is required}"

bash scripts/prepare-firebase-web.sh
bash scripts/sync-web-icons.sh

BUILD_ARGS=(
  build web --release
  "--dart-define=WPGG_FIREBASE_API_KEY=$WPGG_FIREBASE_API_KEY"
  "--dart-define=WPGG_FIREBASE_VAPID_KEY=$WPGG_FIREBASE_VAPID_KEY"
)

if [[ -n "${WPGG_BASE_URL:-}" ]]; then
  BUILD_ARGS+=("--dart-define=WPGG_BASE_URL=$WPGG_BASE_URL")
fi

flutter "${BUILD_ARGS[@]}"

cp -f web/firebase-config.js build/web/firebase-config.js
