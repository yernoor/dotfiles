#!/bin/bash

set -e  # Exit on any error

echo "=== Installing Zsh ==="
sudo apt update
sudo apt install -y zsh

echo ""
echo "=== Installing Oh-My-Zsh ==="
# Check if oh-my-zsh is already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh-My-Zsh is already installed. Skipping..."
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo ""
echo "=== Installing Catppuccin Theme ==="
# Clone the theme repository
cd /tmp
if [ -d "catppuccin-zsh" ]; then
    rm -rf catppuccin-zsh
fi
git clone https://github.com/JannoTjarks/catppuccin-zsh.git

# Create themes directory
mkdir -p ~/.oh-my-zsh/themes/catppuccin-flavors

# Create symbolic links
ln -sf /tmp/catppuccin-zsh/catppuccin.zsh-theme ~/.oh-my-zsh/themes/
ln -sf /tmp/catppuccin-zsh/catppuccin-flavors/* ~/.oh-my-zsh/themes/catppuccin-flavors/

echo ""
echo "=== Configuring .zshrc ==="
# Backup existing .zshrc
cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)

# Update or add ZSH_THEME
if grep -q "^ZSH_THEME=" ~/.zshrc; then
    # Replace existing ZSH_THEME line
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="catppuccin"/' ~/.zshrc
    echo "Updated existing ZSH_THEME setting"
else
    # Add ZSH_THEME if it doesn't exist
    echo 'ZSH_THEME="catppuccin"' >> ~/.zshrc
    echo "Added ZSH_THEME setting"
fi

# Add Catppuccin configuration if not already present
if ! grep -q "CATPPUCCIN_FLAVOR=" ~/.zshrc; then
    echo 'CATPPUCCIN_FLAVOR="latte"' >> ~/.zshrc
    echo "Added CATPPUCCIN_FLAVOR setting"
fi

if ! grep -q "CATPPUCCIN_SHOW_TIME=" ~/.zshrc; then
    echo 'CATPPUCCIN_SHOW_TIME=true' >> ~/.zshrc
    echo "Added CATPPUCCIN_SHOW_TIME setting"
fi

echo ""
echo "=== Setup Complete! ==="
echo "A backup of your .zshrc was created"
echo ""
echo "To start using Zsh with your new theme:"
echo "1. Run: zsh"
echo "2. Or set Zsh as default shell: chsh -s $(which zsh)"
echo "3. Then restart your terminal"
echo ""
echo "Current shell: $SHELL"
