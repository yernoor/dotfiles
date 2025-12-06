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
echo "=== Select Catppuccin Flavor ==="
echo "Available flavors:"
echo "  1) latte (light theme)"
echo "  2) mocha (dark theme)"
echo "  3) frappe (dark theme)"
echo "  4) macchiato (dark theme)"
echo ""

# Prompt for flavor selection
while true; do
    read -p "Enter your choice (1-4): " choice
    case $choice in
        1) FLAVOR="latte"; break;;
        2) FLAVOR="mocha"; break;;
        3) FLAVOR="frappe"; break;;
        4) FLAVOR="macchiato"; break;;
        *) echo "Invalid choice. Please enter 1, 2, 3, or 4.";;
    esac
done

echo "Selected flavor: $FLAVOR"

echo ""
echo "=== Configuring .zshrc ==="
# Backup existing .zshrc
cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)

# Remove old Catppuccin configuration if it exists anywhere
sed -i '/^CATPPUCCIN_FLAVOR=/d' ~/.zshrc
sed -i '/^CATPPUCCIN_SHOW_TIME=/d' ~/.zshrc

# Update or add ZSH_THEME and add Catppuccin config right below it
if grep -q "^ZSH_THEME=" ~/.zshrc; then
    # Replace existing ZSH_THEME line and add Catppuccin config below in-place
    sed -i "/^ZSH_THEME=/a\\
CATPPUCCIN_FLAVOR=\"$FLAVOR\"\\
CATPPUCCIN_SHOW_TIME=true" ~/.zshrc
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="catppuccin"/' ~/.zshrc
    echo "Updated existing ZSH_THEME setting"
else
    # Find a good place to insert (before sourcing oh-my-zsh or at the beginning)
    if grep -q "source.*oh-my-zsh.sh" ~/.zshrc; then
        # Insert before the source line
        sed -i "/source.*oh-my-zsh.sh/i\\
ZSH_THEME=\"catppuccin\"\\
CATPPUCCIN_FLAVOR=\"$FLAVOR\"\\
CATPPUCCIN_SHOW_TIME=true\\
" ~/.zshrc
    else
        # Insert at the beginning after shebang/comments
        sed -i "1a\\
ZSH_THEME=\"catppuccin\"\\
CATPPUCCIN_FLAVOR=\"$FLAVOR\"\\
CATPPUCCIN_SHOW_TIME=true" ~/.zshrc
    fi
    echo "Added ZSH_THEME setting"
fi

echo ""
echo "=== Setup Complete! ==="
echo "A backup of your .zshrc was created"
echo "Selected theme flavor: $FLAVOR"
echo ""
echo "To start using Zsh with your new theme:"
echo "1. Run: zsh"
echo "2. Or set Zsh as default shell: chsh -s $(which zsh)"
echo "3. Then restart your terminal"
echo ""
echo "Current shell: $SHELL"