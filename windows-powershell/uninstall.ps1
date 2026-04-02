# Desinstalador de FAAAAH-Listener para Windows (PowerShell)
Write-Host "Desinstalando FAAAAH-Listener..." -ForegroundColor Red

$WIN_DIR = "C:\Users\Public\.faaaah-listener"

# 1. Borrar carpeta de instalación en C:\Users\Public\
if (Test-Path $WIN_DIR) {
    Remove-Item -Path $WIN_DIR -Recurse -Force
    Write-Host "✔ Carpeta de Windows eliminada ($WIN_DIR)."
}

# 2. Limpiar el perfil de PowerShell
if (Test-Path $PROFILE) {
    $ProfileLines = Get-Content $PROFILE -ErrorAction SilentlyContinue
    if ($ProfileLines) {
        $CleanLines = $ProfileLines | Where-Object { 
            $_ -notmatch "# FAAAAH-Listener" -and $_ -notmatch "\.faaaah-listener\\FAAAAH-listener\.ps1" 
        }
        
        Set-Content -Path $PROFILE -Value $CleanLines
        Write-Host "✔ Rastro limpiado en tu perfil ($PROFILE)."
    }
}

Write-Host "¡Desinstalación completa!" -ForegroundColor Green
Write-Host "El sistema está limpio. Para eliminar el comportamiento en esta sesión, reinicia la terminal."
