#!/bin/bash

# ============================
# Arch Linux Installer & Updater (With AUR + Dotfiles)
# ============================
# Installs system packages, detects the desktop environment, 
# updates all installed packages, installs yay, and stows dotfiles.
#
# Author: Jacob Soderblom
# Version: 2.7 (Final)
# ----------------------------

set -e  # Exit script immediately on error

# ----------------------------
# 📂 Configuration
# ----------------------------
DOTFILES_REPO="https://github.com/JacobSoderblom/.dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

# ----------------------------
# 🔍 Ensure script is run as sudo
# ----------------------------
if [[ $EUID -ne 0 ]]; then
    echo "❌ Please run this script with sudo." >&2
    exit 1
fi

USERNAME=${SUDO_USER:-$(logname)}  # Get real username if run as root

# ----------------------------
# 📦 Package Lists (Easily Editable)
# ----------------------------

# 🔧 Base Packages (Official)
BASE_PACMAN_PACKAGES=(
    git stow curl wget unzip tar
    gcc make ripgrep fd neovim
    starship tmux wezterm zsh
    zsh-completions zsh-syntax-highlighting
    ttf-nerd-fonts-symbols
)

# 🌐 Base AUR Packages
BASE_AUR_PACKAGES=(
    tmuxifier
)

# 🌐 Hyprland Packages (Official)
HYPRLAND_PACMAN_PACKAGES=(
    hypridle hyprlock hyprpaper
    waybar
)

# 🌐 Hyprland AUR Packages
HYPRLAND_AUR_PACKAGES=(
    swaync swayosd
)

# 🏠 i3 Packages (Official)
I3_PACMAN_PACKAGES=(
    i3lock feh dunst
    xorg-xbacklight i3blocks
)

# ----------------------------
# 🔄 System Update
# ----------------------------
echo "🔄 Updating system packages..."
pacman -Syu --noconfirm

# ----------------------------
# 📥 Install Essential Tools
# ----------------------------
echo "📥 Installing base packages (pacman)..."
pacman -S --noconfirm --needed "${BASE_PACMAN_PACKAGES[@]}"

# ----------------------------
# 🚀 Install Yay (AUR Helper)
# ----------------------------
if ! command -v yay &>/dev/null; then
    echo "📥 Installing yay (AUR package manager)..."
    pacman -S --needed --noconfirm base-devel
    rm -rf /tmp/yay-bin
    su -c "git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin && cd /tmp/yay-bin && makepkg -si --noconfirm && rm -rf /tmp/yay-bin" $USERNAME
else
    echo "✅ Yay is already installed. Updating yay..."
    su -c "yay -Syu --noconfirm" $USERNAME
fi

# ----------------------------
# 🌍 Detect Desktop Environment
# ----------------------------
if pgrep -x "Hyprland" >/dev/null; then
    DESKTOP_ENV="hyprland"
    PACMAN_PACKAGES=("${HYPRLAND_PACMAN_PACKAGES[@]}")
    AUR_PACKAGES=("${HYPRLAND_AUR_PACKAGES[@]}")
elif pgrep -x "i3" >/dev/null || pgrep -x "i3bar" >/dev/null; then
    DESKTOP_ENV="i3"
    PACMAN_PACKAGES=("${I3_PACMAN_PACKAGES[@]}")
    AUR_PACKAGES=()
else
    DESKTOP_ENV="other"
    PACMAN_PACKAGES=()
    AUR_PACKAGES=()
fi

echo "🖥️ Detected Environment: $DESKTOP_ENV"

# ----------------------------
# 📦 Install Desktop-Specific Packages
# ----------------------------
if [[ ${#PACMAN_PACKAGES[@]} -gt 0 ]]; then
    echo "📦 Installing $DESKTOP_ENV-specific packages (pacman)..."
    pacman -S --noconfirm --needed "${PACMAN_PACKAGES[@]}"
fi

# ----------------------------
# 📥 Install Base AUR Packages
# ----------------------------
echo "📥 Installing base packages (AUR)..."
su -c "yay -S --noconfirm --needed ${BASE_AUR_PACKAGES[*]}" $USERNAME

if [[ ${#AUR_PACKAGES[@]} -gt 0 ]]; then
    echo "📦 Installing $DESKTOP_ENV-specific packages (AUR)..."
    su -c "yay -S --noconfirm --needed ${AUR_PACKAGES[*]}" $USERNAME
fi

# ----------------------------
# 🦀 Install Rust via Official Installer
# ----------------------------
echo "🦀 Installing Rust..."
su -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y' $USERNAME
su -c 'source $HOME/.cargo/env' $USERNAME

# ----------------------------
# ⚡ Install or Update Oh My Zsh
# ----------------------------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    su -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended' $USERNAME
else
    su -c "omz update" $USERNAME
fi

# ----------------------------
# 🛠️ Set Zsh as Default Shell
# ----------------------------
if [[ "$(getent passwd $USERNAME | cut -d: -f7)" != "$(which zsh)" ]]; then
    chsh -s "$(which zsh)" $USERNAME
fi

# ----------------------------
# 📂 Clone and Stow Dotfiles
# ----------------------------
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "📥 Cloning dotfiles from $DOTFILES_REPO..."
    su -c "git clone $DOTFILES_REPO $DOTFILES_DIR" $USERNAME || { echo "❌ Failed to clone dotfiles! Exiting..."; exit 1; }
fi

# Ensure correct user ownership
chown -R $USERNAME:$USERNAME "$DOTFILES_DIR"

cd "$DOTFILES_DIR"

if [ -z "$(find . -mindepth 1 -maxdepth 1 -type d)" ]; then
    echo "⚠️ No directories found to stow. Skipping..."
else
    for dir in $(find . -mindepth 1 -maxdepth 1 -type d); do
        su -c "stow -v $(basename "$dir")" $USERNAME
    done
fi

# ----------------------------
# 🎉 Completion
# ----------------------------
echo "🎉 Installation & update complete! Please reboot or restart your shell."
