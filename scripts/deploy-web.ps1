# Full web deploy: generate Firebase config, build, deploy from build/web.
param(
    [Parameter(Mandatory = $true)]
    [string]$FirebaseApiKey,

    [string]$FirebaseVapidKey = $env:WPGG_FIREBASE_VAPID_KEY,

    [string]$BaseUrl = $env:WPGG_BASE_URL
)

if (-not $FirebaseVapidKey) {
    Write-Error 'WPGG_FIREBASE_VAPID_KEY is required (env var or -FirebaseVapidKey).'
    exit 1
}

$env:WPGG_FIREBASE_API_KEY = $FirebaseApiKey
& (Join-Path $PSScriptRoot 'prepare-firebase-web.ps1')

$buildArgs = @(
    'build', 'web', '--release',
    "--dart-define=WPGG_FIREBASE_API_KEY=$FirebaseApiKey",
    "--dart-define=WPGG_FIREBASE_VAPID_KEY=$FirebaseVapidKey"
)

if ($BaseUrl) {
    $buildArgs += "--dart-define=WPGG_BASE_URL=$BaseUrl"
}

Push-Location (Split-Path -Parent $PSScriptRoot)
try {
    flutter @buildArgs
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    Copy-Item -Force (Join-Path $PWD 'web/firebase-config.js') (Join-Path $PWD 'build/web/firebase-config.js')

    Push-Location 'build/web'
    vercel --prod
} finally {
    Pop-Location
    if ((Get-Location).Path -ne (Split-Path -Parent $PSScriptRoot)) { Pop-Location }
}
