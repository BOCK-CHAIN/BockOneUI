param(
  [switch]$SkipDownload
)

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $projectRoot

function Resolve-GoExe {
  $goCmd = Get-Command go -ErrorAction SilentlyContinue
  if ($goCmd -and $goCmd.Source) {
    return $goCmd.Source
  }

  $localGo = Join-Path $projectRoot ".tools\go\bin\go.exe"
  if (Test-Path $localGo) {
    return $localGo
  }

  return $null
}

$goExe = Resolve-GoExe

if (-not $goExe) {
  if ($SkipDownload) {
    throw "Go was not found in PATH and local toolchain is missing."
  }

  $toolsDir = Join-Path $projectRoot ".tools"
  $goZip = Join-Path $toolsDir "go1.22.5.windows-amd64.zip"
  $goDir = Join-Path $toolsDir "go"

  New-Item -ItemType Directory -Path $toolsDir -Force | Out-Null

  Write-Host "Downloading Go toolchain..."
  Invoke-WebRequest -Uri "https://go.dev/dl/go1.22.5.windows-amd64.zip" -OutFile $goZip

  if (Test-Path $goDir) {
    Remove-Item -Path $goDir -Recurse -Force
  }

  Write-Host "Extracting Go toolchain..."
  Expand-Archive -Path $goZip -DestinationPath $toolsDir -Force

  $goExe = Join-Path $goDir "bin\go.exe"
}

$goBinDir = Split-Path -Parent $goExe
$env:Path = "$goBinDir;$env:Path"

Write-Host "Using Go at: $goExe"
& $goExe version

Write-Host "Downloading Go modules..."
& $goExe mod download

Write-Host "Starting BockVote backend..."
& $goExe run main.go
