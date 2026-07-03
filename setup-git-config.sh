#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIGS_DIR="$SCRIPT_DIR/configs"

# Welcome message
echo -e "${BLUE}Git Configuration Setup${NC}\n"

# Check if configs directory exists
if [ ! -d "$CONFIGS_DIR" ]; then
    echo -e "${RED}Error: configs directory not found at: $CONFIGS_DIR${NC}"
    exit 1
fi

# Check if required files exist
required_files=(".gitconfig" ".gitconfig-lite" ".gitignore_global" ".gitmessage")
for file in "${required_files[@]}"; do
    if [ ! -f "$CONFIGS_DIR/$file" ]; then
        echo -e "${RED}Error: Required file '$file' not found in configs directory${NC}"
        exit 1
    fi
done

# Get user input
read -p "Enter your full name: " git_name
read -p "Enter your email: " git_email

# Get configuration choice
echo -e "\nSelect Git configuration type:"
echo "1. Full (Advanced features and optimizations)"
echo "2. Lite (Basic features)"
read -p "Enter your choice (1 or 2): " choice

# Set source config file based on choice
if [ "$choice" = "1" ]; then
    source_config="$CONFIGS_DIR/.gitconfig"
    echo -e "\n${BLUE}Creating full configuration...${NC}"
else
    source_config="$CONFIGS_DIR/.gitconfig-lite"
    echo -e "\n${BLUE}Creating lite configuration...${NC}"
fi

# Create temporary file for substitution
temp_config=$(mktemp)

# Replace placeholders with user details
sed "s/\$git_name/$git_name/g; s/\$git_email/$git_email/g" "$source_config" > "$temp_config"

# Copy configuration files to home directory
cp "$temp_config" ~/.gitconfig
cp "$CONFIGS_DIR/.gitignore_global" ~/.gitignore_global
cp "$CONFIGS_DIR/.gitmessage" ~/.gitmessage

# Clean up temporary file
rm "$temp_config"

# Set correct permissions
chmod 644 ~/.gitconfig ~/.gitignore_global ~/.gitmessage

# Verify the installation
if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}Git configuration installed successfully!${NC}"
    echo -e "\n${BLUE}Installed files:${NC}"
    echo "- ~/.gitconfig"
    echo "- ~/.gitignore_global"
    echo "- ~/.gitmessage"
    
    read -p $'\nWould you like to see your git configuration? (y/n): ' show_config
    if [[ $show_config =~ ^[Yy]$ ]]; then
        echo -e "\n${BLUE}Your git configuration:${NC}"
        git config --list
    fi

    echo -e "\n${BLUE}Test your configuration:${NC}"
    echo "1. Create test repo: mkdir test && cd test && git init"
    echo "2. Create file: touch test.txt"
    echo "3. Add file: git add test.txt"
    echo "4. Test commit message: git commit"
else
    echo -e "${RED}Installation failed. Please check the error messages above.${NC}"
    exit 1
fi

# Final instructions
echo -e "\n${GREEN}Setup complete!${NC}"
echo -e "Your Git configuration has been installed and configured successfully."
echo -e "You can find your config files in your home directory:"
echo -e "  ~/.gitconfig"
echo -e "  ~/.gitignore_global"
echo -e "  ~/.gitmessage"