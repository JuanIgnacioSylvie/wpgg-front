# Local web dev with Firebase push (FCM). Generates firebase-config.js + flutter run.
#
# Keys (NOT the Admin SDK JSON — that is for the backend only):
#   WPGG_FIREBASE_API_KEY   → Firebase Console → Project settings → General → Web API Key
#   WPGG_FIREBASE_VAPID_KEY → Firebase Console → Cloud Messaging → Web Push certificates → Key pair
#
# Usage:
#   $env:WPGG_FIREBASE_API_KEY = "AIzaSy..."
#   $env:WPGG_FIREBASE_VAPID_KEY = "BN..."
#   .\scripts\run-web.ps1
#
# Or:
#   .\scripts\run-web.ps1 -FirebaseApiKey "AIzaSy..." -FirebaseVapidKey "BN..."

param(
    [string]$FirebaseApiKey = $env:WPGG_FIREBASE_API_KEY,
    [string]$FirebaseVapidKey = $env:WPGG_FIREBASE_VAPID_KEY,
    [string]$BaseUrl = $env:WPGG_BASE_URL,
    [string]$Device = 'chrome'
)

if (-not $FirebaseApiKey) {
    Write-Error @'
WPGG_FIREBASE_API_KEY is required.

  $env:WPGG_FIREBASE_API_KEY = "AIzaSy..."
  $env:WPGG_FIREBASE_VAPID_KEY = "BN..."
  .\scripts\run-web.ps1
'@
    exit 1
}

if (-not $FirebaseVapidKey) {
    Write-Error @'
WPGG_FIREBASE_VAPID_KEY is required (Web Push public key from Firebase Console → Cloud Messaging).

  $env:WPGG_FIREBASE_VAPID_KEY = "BN..."
  .\scripts\run-web.ps1
'@
    exit 1
}

$env:WPGG_FIREBASE_API_KEY = $FirebaseApiKey
& (Join-Path $PSScriptRoot 'prepare-firebase-web.ps1')
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$runArgs = @(
    'run', '-d', $Device,
    "--dart-define=WPGG_FIREBASE_API_KEY=$FirebaseApiKey",
    "--dart-define=WPGG_FIREBASE_VAPID_KEY=$FirebaseVapidKey"
)

if ($BaseUrl) {
    $runArgs += "--dart-define=WPGG_BASE_URL=$BaseUrl"
}

Push-Location (Split-Path -Parent $PSScriptRoot)
try {
    flutter @runArgs
    exit $LASTEXITCODE
} finally {
    Pop-Location
}
