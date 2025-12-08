#!/bin/bash

set -e  # Exit on any error

echo "=== Checking Zsh Installation ==="

# Check if Oh-My-Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Error: Oh-My-Zsh is not installed. Please run setup_zsh.sh first."
    exit 1
fi

echo "Oh-My-Zsh is installed ✓"

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
sed -i '/^ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=/d' ~/.zshrc

# Update or add ZSH_THEME and add Catppuccin config right below it
if grep -q "^ZSH_THEME=" ~/.zshrc; then
    # Replace existing ZSH_THEME line and add Catppuccin config below in-place
    sed -i "/^ZSH_THEME=/a\\
CATPPUCCIN_FLAVOR=\"$FLAVOR\"\\
CATPPUCCIN_SHOW_TIME=true\\
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=\"fg=cyan\"" ~/.zshrc
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
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=\"fg=cyan\"\\
" ~/.zshrc
    else
        # Insert at the beginning after shebang/comments
        sed -i "1a\\
ZSH_THEME=\"catppuccin\"\\
CATPPUCCIN_FLAVOR=\"$FLAVOR\"\\
CATPPUCCIN_SHOW_TIME=true\\
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=\"fg=cyan\"" ~/.zshrc
    fi
    echo "Added ZSH_THEME setting"
fi

echo ""
echo "=== Catppuccin Theme Setup Complete! ==="
echo "Selected theme flavor: $FLAVOR"
echo ""
echo "To apply changes, run: source ~/.zshrc"
echo "Or restart your terminal"