# Instalador de FAAAAH-Listener para Windows (PowerShell)
Write-Host "Instalando FAAAAH-Listener para PowerShell..." -ForegroundColor Blue

$INSTALL_DIR = "C:\Users\Public\.faaaah-listener"

# Crear directorio
if (-not (Test-Path $INSTALL_DIR)) {
    New-Item -ItemType Directory -Path $INSTALL_DIR | Out-Null
}

# Obtener ruta de los archivos. El archivo .wav está en el directorio padre por diseño de repo.
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
if (-not $PSScriptRoot) { $PSScriptRoot = $PWD }
$ParentRoot = Split-Path -Parent -Path $PSScriptRoot

$wavPath = Join-Path -Path $ParentRoot -ChildPath "FAAAAH.wav"
$ps1Path = Join-Path -Path $PSScriptRoot -ChildPath "FAAAAH-listener.ps1"

# Copiar archivos
if (Test-Path $wavPath) {
    Copy-Item -Path $wavPath -Destination $INSTALL_DIR -Force
} else {
    Write-Host "⚠️ No se encontró el archivo FAAAAH.wav en el directorio padre ($ParentRoot)." -ForegroundColor Yellow
}

if (Test-Path $ps1Path) {
    Copy-Item -Path $ps1Path -Destination $INSTALL_DIR -Force
} else {
    Write-Host "⚠️ No se encontró el archivo FAAAAH-listener.ps1 en ($PSScriptRoot)." -ForegroundColor Yellow
}

# Integración con la configuración del perfil de PowerShell ($PROFILE)
if (-not (Test-Path $PROFILE)) {
    # Asegurar que la ruta base existe
    $profileDir = Split-Path $PROFILE -Parent
    if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir | Out-Null }
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$ProfileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
$SourceLine = ". `"$INSTALL_DIR\FAAAAH-listener.ps1`""

if ($ProfileContent -match "FAAAAH-listener\.ps1") {
    Write-Host "Ya estaba configurado en tu perfil. Task failed successfully."
} else {
    Add-Content -Path $PROFILE -Value "`n# FAAAAH-Listener`n$SourceLine"
    Write-Host "¡Instalación completada!" -ForegroundColor Green
    Write-Host "Para aplicar los cambios, reinicia tu terminal o ejecuta:"
    Write-Host ". `$PROFILE"
}
