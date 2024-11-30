#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Git Configuration Setup Script${NC}"
echo "----------------------------------------"

# Get user input
read -p "Enter your full name: " git_name
read -p "Enter your email: " git_email

# Copy configuration files
cp configs/.gitconfig ~/.gitconfig
cp configs/.gitignore_global ~/.gitignore_global
cp configs/.gitmessage ~/.gitmessage

# Update git configuration with user details
sed -i "s/name = .*/name = $git_name/" ~/.gitconfig
sed -i "s/email = .*/email = $git_email/" ~/.gitconfig

# Set permissions
chmod 644 ~/.gitconfig ~/.gitignore_global ~/.gitmessage

# Verify installation
if [ $? -eq 0 ]; then
   echo -e "${GREEN}Git configuration installed successfully!${NC}"
   echo -e "\n${BLUE}Installed files:${NC}"
   echo "- ~/.gitconfig"
   echo "- ~/.gitignore_global"
   echo "- ~/.gitmessage"
   
   read -p "Would you like to see your git configuration? (y/n): " show_config
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