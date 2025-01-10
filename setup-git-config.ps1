# Windows Git Configuration Script

# Set console colors
$RED = "`e[31m"
$GREEN = "`e[32m"
$BLUE = "`e[34m"
$NC = "`e[0m"

# Welcome message
Write-Host "${BLUE}Git Configuration Setup${NC}`n"

# Get user details
$git_name = Read-Host "Enter your full name"
$git_email = Read-Host "Enter your email"

# Get configuration choice
Write-Host "`nSelect Git configuration type:"
Write-Host "1. Full (Advanced features and optimizations)"
Write-Host "2. Lite (Basic features)"
$choice = Read-Host "Enter your choice (1 or 2)"

# Set paths
$homeDir = $env:USERPROFILE
$gitConfig = Join-Path $homeDir ".gitconfig"
$gitIgnore = Join-Path $homeDir ".gitignore_global"
$gitMessage = Join-Path $homeDir ".gitmessage"

# Source config files
$configsPath = Join-Path $PSScriptRoot "configs"
$fullConfigPath = Join-Path $configsPath ".gitconfig"
$liteConfigPath = Join-Path $configsPath ".gitconfig-lite"

try {
    # Verify config files exist
    if (-not (Test-Path $fullConfigPath)) {
        throw "Full configuration file not found at: $fullConfigPath"
    }
    if (-not (Test-Path $liteConfigPath)) {
        throw "Lite configuration file not found at: $liteConfigPath"
    }

    # Select and read appropriate config file
    if ($choice -eq "1") {
        $selectedConfig = Get-Content $fullConfigPath -Raw
        Write-Host "`n${BLUE}Creating full configuration...${NC}"
    } else {
        $selectedConfig = Get-Content $liteConfigPath -Raw
        Write-Host "`n${BLUE}Creating lite configuration...${NC}"
    }

    # Replace placeholders with user details
    $selectedConfig = $selectedConfig.Replace('$git_name', $git_name).Replace('$git_email', $git_email)
    
    # Copy configuration files
    $selectedConfig | Set-Content $gitConfig -Force
    Copy-Item (Join-Path $configsPath ".gitignore_global") $gitIgnore -Force
    Copy-Item (Join-Path $configsPath ".gitmessage") $gitMessage -Force

    # Convert Windows paths to Git-style paths
    $gitIgnorePath = $gitIgnore.Replace("\", "/")
    $gitMessagePath = $gitMessage.Replace("\", "/")
    
    # Update paths in .gitconfig
    git config --global core.excludesfile $gitIgnorePath
    git config --global commit.template $gitMessagePath

    # Verify installation
    Write-Host "`n${GREEN}Git configuration installed successfully!${NC}"
    Write-Host "`n${BLUE}Installed files:${NC}"
    Write-Host "- $gitConfig"
    Write-Host "- $gitIgnore"
    Write-Host "- $gitMessage"

    $show_config = Read-Host "`nWould you like to see your git configuration? (y/n)"
    if ($show_config -match '^[Yy]$') {
        Write-Host "`n${BLUE}Your git configuration:${NC}"
        git config --list
    }

    Write-Host "`n${BLUE}Test your configuration:${NC}"
    Write-Host "1. Create test repo: mkdir test; cd test; git init"
    Write-Host "2. Create file: New-Item test.txt"
    Write-Host "3. Add file: git add test.txt"
    Write-Host "4. Test commit message: git commit"
}
catch {
    Write-Host "${RED}Installation failed. Error: $($_.Exception.Message)${NC}"
    exit 1
}