# Full web deploy: generate Firebase config, build, deploy from build/web.
#
# Keys can come from:
#   - Parameters / shell env vars (WPGG_FIREBASE_*)
#   - Vercel project env: .\scripts\deploy-web.ps1 -FromVercel
#
param(
    [string]$FirebaseApiKey = $env:WPGG_FIREBASE_API_KEY,
    [string]$FirebaseVapidKey = $env:WPGG_FIREBASE_VAPID_KEY,
    [string]$BaseUrl = $env:WPGG_BASE_URL,
    [switch]$FromVercel
)

$root = Split-Path -Parent $PSScriptRoot

if ($FromVercel) {
    $envFile = Join-Path $root '.env.vercel.local'
    vercel env pull $envFile --environment=production --yes
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^\s*([^#=]+)=(.*)$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim().Trim('"')
            if ($value) {
                Set-Item -Path "env:$name" -Value $value
            }
        }
    }

    if (-not $FirebaseApiKey) { $FirebaseApiKey = $env:WPGG_FIREBASE_API_KEY }
    if (-not $FirebaseVapidKey) { $FirebaseVapidKey = $env:WPGG_FIREBASE_VAPID_KEY }
    if (-not $BaseUrl) { $BaseUrl = $env:WPGG_BASE_URL }
}

if (-not $FirebaseApiKey) {
    $vercelHasNames = $false
    $envFile = Join-Path $root '.env.vercel.local'
    if (Test-Path $envFile) {
        $vercelHasNames = @(Select-String -Path $envFile -Pattern '^WPGG_FIREBASE_API_KEY=').Count -gt 0
    }
    $hint = if ($FromVercel -and $vercelHasNames) {
@'

Vercel tiene WPGG_FIREBASE_API_KEY pero el valor llegó vacío.
En vercel.com → wpgg-front → Settings → Environment Variables:
  1. Editá WPGG_FIREBASE_API_KEY y pegá AIzaSy... (Firebase Console → Web API Key)
  2. Editá WPGG_FIREBASE_VAPID_KEY y pegá BN... (Firebase → Cloud Messaging → Web Push)
  3. Volvé a correr: .\scripts\deploy-web.ps1 -FromVercel
'@
    } else {
@'

  .\scripts\deploy-web.ps1 -FirebaseApiKey "AIzaSy..." -FirebaseVapidKey "BN..."
  # o guardalas en Vercel (con valor, no vacías) y corré:
  .\scripts\deploy-web.ps1 -FromVercel
'@
    }
    Write-Error "WPGG_FIREBASE_API_KEY is required.$hint"
    exit 1
}

if (-not $FirebaseVapidKey) {
    Write-Error 'WPGG_FIREBASE_VAPID_KEY is required (env var, -FirebaseVapidKey, or -FromVercel).'
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
