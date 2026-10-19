# Frpc Watchdog Script
# This script automatically restarts frpc if it crashes.

$frpcProcessName = "frpc"
$frpcExecutablePath = "D:\Your\FRP\Path\frpc.exe"  # CHANGE THIS to your actual path
$frpcConfigPath = "D:\Your\FRP\Path\frpc.ini"      # CHANGE THIS to your actual path

Write-Host "[INFO] Frpc Watchdog is running. Press Ctrl+C to stop." -ForegroundColor Green

while ($true) {
    # Check if frpc process is running
    $processExists = Get-Process -Name $frpcProcessName -ErrorAction SilentlyContinue

    if (-not $processExists) {
        Write-Host "[WARN] Frpc is not running. Starting it now..." -ForegroundColor Yellow
        try {
            # Start frpc process hidden
            Start-Process -FilePath $frpcExecutablePath -ArgumentList "-c", $frpcConfigPath -WindowStyle Hidden
            Write-Host "[SUCCESS] Frpc started successfully." -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] Failed to start frpc: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "[INFO] Frpc is alive. PID: $($processExists.Id)" -ForegroundColor Cyan
    }

    # Wait for 10 seconds before checking again
    Start-Sleep -Seconds 10
}