$ErrorActionPreference = "Stop"
$repositoryUrl = "https://raw.githubusercontent.com/shahinabdi/git-config/main"
$homeDir = $env:USERPROFILE
$gitConfig = Join-Path $homeDir ".gitconfig"
$gitIgnore = Join-Path $homeDir ".gitignore_global"
$gitMessage = Join-Path $homeDir ".gitmessage"
$localConfigsPath = if ([string]::IsNullOrWhiteSpace($PSScriptRoot)) {
    $null
} else {
    Join-Path $PSScriptRoot "configs"
}
$temporaryConfigsPath = Join-Path ([System.IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString())
$stagedConfig = Join-Path $temporaryConfigsPath ".gitconfig"

try {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw "Git is not installed or is not available in PATH."
    }

    New-Item -ItemType Directory -Path $temporaryConfigsPath | Out-Null
    if ($localConfigsPath -and (Test-Path $localConfigsPath)) {
        $configsPath = $localConfigsPath
    } else {
        $configsPath = $temporaryConfigsPath
        foreach ($file in @(".gitconfig", ".gitconfig-lite", ".gitignore_global", ".gitmessage")) {
            $url = "$repositoryUrl/configs/$file"
            Invoke-WebRequest -Uri $url -OutFile (Join-Path $configsPath $file) -UseBasicParsing
        }
    }

    foreach ($file in @(".gitconfig", ".gitconfig-lite", ".gitignore_global", ".gitmessage")) {
        if (-not (Test-Path (Join-Path $configsPath $file))) {
            throw "Required configuration file is missing: $file"
        }
    }

    Write-Host "Git Configuration Setup`n" -ForegroundColor Blue
    $gitName = Read-Host "Enter your full name"
    $gitEmail = Read-Host "Enter your email"
    if ([string]::IsNullOrWhiteSpace($gitName)) { throw "Name cannot be empty." }
    if ([string]::IsNullOrWhiteSpace($gitEmail)) { throw "Email cannot be empty." }

    Write-Host "`nSelect Git configuration type:"
    Write-Host "1. Full (advanced features)"
    Write-Host "2. Lite (essential features)"
    $choice = Read-Host "Enter your choice (1 or 2)"
    switch ($choice) {
        "1" { $selectedConfig = Join-Path $configsPath ".gitconfig"; $configType = "full" }
        "2" { $selectedConfig = Join-Path $configsPath ".gitconfig-lite"; $configType = "lite" }
        default { throw "Choose 1 for Full or 2 for Lite." }
    }

    Copy-Item $selectedConfig $stagedConfig -Force
    & git config --file $stagedConfig user.name $gitName
    if ($LASTEXITCODE -ne 0) { throw "Could not set the Git user name." }
    & git config --file $stagedConfig user.email $gitEmail
    if ($LASTEXITCODE -ne 0) { throw "Could not set the Git user email." }

    Copy-Item $stagedConfig $gitConfig -Force
    Copy-Item (Join-Path $configsPath ".gitignore_global") $gitIgnore -Force
    Copy-Item (Join-Path $configsPath ".gitmessage") $gitMessage -Force

    Write-Host "`nGit $configType configuration installed successfully." -ForegroundColor Green
    Write-Host "Installed: $gitConfig, $gitIgnore, $gitMessage"
    Write-Host "Configured identity: $gitName <$gitEmail>"
} catch {
    Write-Host "Installation failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
} finally {
    if (Test-Path $temporaryConfigsPath) {
        Remove-Item $temporaryConfigsPath -Recurse -Force
    }
}