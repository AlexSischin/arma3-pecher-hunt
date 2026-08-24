$ErrorActionPreference = "Stop"

# ==============================
# Configuration
# ==============================

$ArmaDir = "C:\Program Files (x86)\Steam\steamapps\common\Arma 3"
$ConfigFile = "C:\Users\alexei\Documents\Arma 3\mpmissions\pecher_massacre.carter_winter\server.cfg"
$ServerName = "S"

# ==============================
# Mods
# ==============================

$Mods = @(
    "!Workshop\@CUP Terrains - Core"
    "!Workshop\@CUP Terrains - Maps"
    "!Workshop\@CUP Terrains - CWA"
    "!Workshop\@CBA_A3"
    "!Workshop\@Improved Melee System"
    "!Workshop\@WebKnight's Zombies and Creatures"
    "!Workshop\@RHSAFRF"
    "!Workshop\@RHSUSAF"
    "!Workshop\@ace"
    "!Workshop\@Pecher"
)

# ==============================
# Launch server
# ==============================

try {
    $ServerExe = Join-Path $ArmaDir "arma3server_x64.exe"

    if (-not (Test-Path $ServerExe)) {
        throw "Arma 3 server executable not found: $ServerExe"
    }

    if (-not (Test-Path $ConfigFile)) {
        throw "Server config file not found: $ConfigFile"
    }

    $ModList = $Mods -join ";"

    $Arguments = @(
        "-config=`"$ConfigFile`""
        "-enableHT"
        "-name=$ServerName"
        "-mod=`"$ModList`""
    )

    $Process = Start-Process `
        -FilePath $ServerExe `
        -ArgumentList $Arguments `
        -WorkingDirectory $ArmaDir `
        -Wait `
        -PassThru

    Write-Host "`nServer process exited with code $($Process.ExitCode)" -ForegroundColor Yellow
}
catch {
    Write-Host "`nERROR: $_" -ForegroundColor Red
}
finally {
    Write-Host "`nPress any key to close this window..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
