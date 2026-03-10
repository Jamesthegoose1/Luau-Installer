# install-luau.ps1

$installDir = "$env:USERPROFILE\bin"
if (-not (Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir | Out-Null }

# Fetch latest Luau release info
$release = Invoke-RestMethod "https://api.github.com/repos/luau-lang/luau/releases/latest"
$asset = $release.assets | Where-Object { $_.name -eq "luau-windows.zip" }

$zipPath = Join-Path $installDir "luau-windows.zip"
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath

# Extract
Expand-Archive -LiteralPath $zipPath -DestinationPath $installDir -Force
Remove-Item $zipPath

# Add bin to PATH if not already
$currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
if (-not $currentPath.Split(";") -contains $installDir) {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$installDir", [EnvironmentVariableTarget]::User)
    Write-Host "Added $installDir to PATH. Restart terminal to use 'luau' directly." -ForegroundColor Yellow
}

# Verify
& "$installDir\luau.exe" -v
