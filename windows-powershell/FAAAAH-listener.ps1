# FAAAAH-Listener para PowerShell

# Evitar carga doble
if ($global:FAAAAH_INIT) { return }
$global:FAAAAH_INIT = $true

$FAAAAH_WAV = "C:\Users\Public\.faaaah-listener\FAAAAH.wav"

if (Test-Path $FAAAAH_WAV) {
    # Hacemos una copia de seguridad de la función prompt original
    if (-not (Get-Command -Name prompt_faaaah_backup -ErrorAction SilentlyContinue)) {
        Rename-Item -Path "Function:\prompt" -NewName "prompt_faaaah_backup" -ErrorAction SilentlyContinue
    }

    function prompt {
        $lastResult = $?

        # Si el resultado es falso (hubo error), reproducimos el sonido
        if (-not $lastResult) {
            # Se ejecuta en segundo plano para no bloquear el prompt
            Start-Process powershell -WindowStyle Hidden -ArgumentList "-NoProfile", "-Command", "(New-Object Media.SoundPlayer '$FAAAAH_WAV').PlaySync()"
        }

        # Restaurar la ejecución del prompt original
        if (Get-Command -Name prompt_faaaah_backup -ErrorAction SilentlyContinue) {
            prompt_faaaah_backup
        } else {
            "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
        }
    }
}
