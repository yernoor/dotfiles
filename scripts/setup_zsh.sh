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
echo "=== Installing zsh-autosuggestions Plugin ==="
# Clone zsh-autosuggestions into custom plugins directory
if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "zsh-autosuggestions is already installed. Skipping..."
else
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Add zsh-autosuggestions to plugins if not already present
if grep -q "^plugins=(" ~/.zshrc; then
    # Check if zsh-autosuggestions is already in the plugins list
    if ! grep "plugins=(" ~/.zshrc | grep -q "zsh-autosuggestions"; then
        # Add zsh-autosuggestions to existing plugins array
        sed -i '/^plugins=(/,/)/ {
            /^plugins=(/ a\    zsh-autosuggestions
        }' ~/.zshrc
        echo "Added zsh-autosuggestions to plugins"
    else
        echo "zsh-autosuggestions already in plugins list"
    fi
else
    # No plugins line exists, create one
    if grep -q "source.*oh-my-zsh.sh" ~/.zshrc; then
        sed -i "/source.*oh-my-zsh.sh/i\\
plugins=(\\
    zsh-autosuggestions\\
)\\
" ~/.zshrc
    else
        echo "" >> ~/.zshrc
        echo "plugins=(" >> ~/.zshrc
        echo "    zsh-autosuggestions" >> ~/.zshrc
        echo ")" >> ~/.zshrc
    fi
    echo "Created plugins array with zsh-autosuggestions"
fi

echo ""
echo "=== Zsh Setup Complete! ==="
echo ""
echo "To set Zsh as default shell: chsh -s $(which zsh)"
echo "Then restart your terminal"
echo ""
echo "Current shell: $SHELL"