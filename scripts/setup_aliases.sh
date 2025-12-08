#!/bin/bash

set -e  # Exit on any error

echo "=== Checking Zsh Installation ==="

# Check if Zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "Error: Zsh is not installed. Please run the setup script first."
    exit 1
fi

# Check if Oh-My-Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Error: Oh-My-Zsh is not installed. Please run the setup script first."
    exit 1
fi

echo "Zsh and Oh-My-Zsh are installed ✓"

echo ""
echo "=== Copying Aliases File ==="

# Get the script's directory (scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Go up one level to get the parent directory
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# Path to source aliases file
ALIASES_SOURCE="$PARENT_DIR/zsh/aliases.zsh"

# Check if source file exists
if [ ! -f "$ALIASES_SOURCE" ]; then
    echo "Error: Source file not found at: $ALIASES_SOURCE"
    exit 1
fi

# Destination path
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
ALIASES_DEST="$ZSH_CUSTOM/aliases.zsh"

# Create backup if destination file already exists
if [ -f "$ALIASES_DEST" ]; then
    BACKUP_FILE="$ALIASES_DEST.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$ALIASES_DEST" "$BACKUP_FILE"
    echo "Existing aliases.zsh backed up to: $BACKUP_FILE"
fi

# Copy the aliases file
cp "$ALIASES_SOURCE" "$ALIASES_DEST"

echo "Aliases file copied to: $ALIASES_DEST"

echo ""
echo "=== Setup Complete! ==="
echo "Your custom aliases have been installed."
echo "They will be automatically loaded when you start a new Zsh session."
echo ""
echo "To apply changes immediately, run: source ~/.zshrc"