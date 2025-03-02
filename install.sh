#!/bin/bash

# ============================
# Arch Linux Installer & Updater (With AUR + Dotfiles)
# ============================
# Installs system packages, detects the desktop environment, 
# updates all installed packages, installs yay, and stows dotfiles.
# ----------------------------

USERNAME=$(id -un 1000 2>/dev/null || logname)  # Get real username if run as root

# ----------------------------
# 📂 Configuration
# ----------------------------
DOTFILES_REPO="https://github.com/JacobSoderblom/.dotfiles.git"
DOTFILES_DIR="/home/$USERNAME/.dotfiles"
GITCONFIG_USER="/home/$USERNAME/.gitconfig-user"
SSH_KEY="/home/$USERNAME/.ssh/id_ed25519"

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

ensure_gpg_key() {
    local GPG_LABEL=$1  
    local GPG_KEY_ID
    local GPG_KEY_TYPE="rsa4096"  # Set key type explicitly

    # Ensure user identity is set
    if [[ -z "$GIT_NAME" || -z "$GIT_EMAIL" ]]; then
        printf "❌ Error: GIT_NAME or GIT_EMAIL is not set. Cannot generate GPG key.\n" >&2
        return 1
    fi

    # Try to retrieve existing GPG key
    GPG_KEY_ID=$(su - "$USERNAME" -c "gpg --list-secret-keys --keyid-format=long" | awk '/^ +/ {print $1}' | grep -E '^[0-9A-F]+' | head -n 1)

    if [[ -z "$GPG_KEY_ID" ]]; then
        read -r -p "No GPG key found for $GPG_LABEL. Generate one? (y/n): " GPG_CHOICE < /dev/tty
        if [[ "$GPG_CHOICE" =~ ^[Yy]$ ]]; then
            printf "🔏 Generating GPG key for %s...\n" "$GPG_LABEL"

            su - "$USERNAME" bash -c "gpg --batch --gen-key" <<EOF
                %echo Generating a GPG key for $GPG_LABEL
                Key-Type: RSA
                Key-Length: 4096
                Name-Real: $GIT_NAME
                Name-Email: $GIT_EMAIL
                Expire-Date: 0
                %no-protection
                %commit
                %echo Done
EOF

            # Re-fetch generated key
            GPG_KEY_ID=$(su - "$USERNAME" -c "gpg --list-secret-keys --keyid-format=long" | awk '/^ +/ {print $1}' | grep -E '^[0-9A-F]+' | head -n 1)

            if [[ -n "$GPG_KEY_ID" ]]; then
                printf "✅ GPG key created: %s for %s\n" "$GPG_KEY_ID" "$GPG_LABEL"
            else
                printf "❌ Error: GPG key creation failed!\n" >&2
                return 1
            fi
        else
            printf "⚠️ Skipping GPG key generation for %s.\n" "$GPG_LABEL"
            return 1
        fi
    fi

    echo "$GPG_KEY_ID"
}

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
    pacman -S --needed --noconfirm base-devel git
    rm -rf /tmp/yay-bin

    # Run the installation as the normal user
    sudo -i -u $USERNAME bash <<EOF
        cd /tmp
        git clone https://aur.archlinux.org/yay-bin.git yay-bin
        cd yay-bin
        makepkg -si --noconfirm --needed
        cd ~
        rm -rf /tmp/yay-bin
EOF

else
    echo "✅ Yay is already installed. Updating yay..."
    sudo -i -u $USERNAME yay -Syu --noconfirm
fi

# ----------------------------
# 📂 Clone and Stow Dotfiles
# ----------------------------
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "📥 Cloning dotfiles from $DOTFILES_REPO..."
    su -c "git clone $DOTFILES_REPO $DOTFILES_DIR" $USERNAME || { echo "❌ Failed to clone dotfiles! Exiting..."; exit 1; }

    # Ensure correct user ownership
    chown -R $USERNAME:$USERNAME "$DOTFILES_DIR"
    
    cd "$DOTFILES_DIR"

    if [ -z "$(find . -mindepth 1 -maxdepth 1 -type d)" ]; then
        echo "⚠️ No directories found to stow. Skipping..."
    else
        echo "🔄 Stowing dotfiles (forcing overwrite of conflicts)..."
        for dir in $(find . -mindepth 1 -maxdepth 1 -type d); do
            echo "🔗 Applying $(basename "$dir")..."
            sudo -u "$USERNAME" stow -R -v "$(basename "$dir")"  # Then, force reapply stow
        done
        echo "✅ Dotfiles successfully applied."
    fi
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
# 🦀 Install Rust (Only If Not Installed)
# ----------------------------
if ! sudo -i -u "$USERNAME" command -v rustc &>/dev/null; then
    echo "🦀 Installing Rust..."
    sudo -i -u "$USERNAME" bash -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'
    echo "✅ Rust installed successfully."
else
    echo "✅ Rust is already installed. Skipping installation."
fi

# ----------------------------
# ⚡ Install or Update Oh My Zsh (Only If Not Installed)
# ----------------------------
OH_MY_ZSH_DIR="/home/$USERNAME/.oh-my-zsh"

if [[ ! -d "$OH_MY_ZSH_DIR" ]]; then
    echo "⚡ Installing Oh My Zsh..."
    sudo -i -u "$USERNAME" sh -c 'curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash --unattended'
    echo "✅ Oh My Zsh installed successfully."
else
    echo "⚠️ Oh My Zsh directory exists but is not properly set up. Skipping installation."
fi

# ----------------------------
# 🛠️ Set Zsh as Default Shell
# ----------------------------
if [[ "$(getent passwd $USERNAME | cut -d: -f7)" != "$(which zsh)" ]]; then
    chsh -s "$(which zsh)" $USERNAME
fi

# ----------------------------
# ✏️ Ensure .gitconfig-user Exists & Prompt for Git Name and Email
# ----------------------------
if [[ ! -f "$GITCONFIG_USER" ]]; then
    echo "📜 Setting up your Git identity..."
    
    # Prompt the user for Git name and email
    read -p "Enter your Git name: " GIT_NAME < /dev/tty
    read -p "Enter your Git email: " GIT_EMAIL < /dev/tty

    # Ensure the file exists and write the user data
    sudo -u "$USERNAME" touch "$GITCONFIG_USER"
    sudo -u "$USERNAME" bash -c "cat <<EOF > '$GITCONFIG_USER'
[user]
    name = $GIT_NAME
    email = $GIT_EMAIL
EOF"

    chown "$USERNAME:$USERNAME" "$GITCONFIG_USER"
    echo "✅ Git identity saved to $GITCONFIG_USER"
else
    echo "✅ Git identity already set. Skipping..."
    GIT_NAME=$(git config --global user.name)
    GIT_EMAIL=$(git config --global user.email)
fi

# ----------------------------
# 🔑 SSH Key Setup for GitHub (Prompt)
# ----------------------------
if [[ ! -f "$SSH_KEY" ]]; then
    read -p "Would you like to generate an SSH key for GitHub? (y/n): " SSH_CHOICE
    if [[ "$SSH_CHOICE" == "y" || "$SSH_CHOICE" == "Y" ]]; then
        echo "🔑 Generating SSH key..."
        su -c "ssh-keygen -t ed25519 -C \"$GIT_EMAIL\" -f \"$SSH_KEY\" -N \"\"" $USERNAME
        echo "✅ SSH key created at $SSH_KEY"

        echo "📜 Copy this SSH key and add it to GitHub:"
        echo "-----------------------------------------"
        su -c "cat $SSH_KEY.pub" $USERNAME
        echo "-----------------------------------------"
        echo "🔗 Go to GitHub: https://github.com/settings/keys"
        echo "🔹 Click 'New SSH Key' and paste the above key."
    else
        echo "⚠️ Skipping SSH key generation."
    fi
else
    echo "✅ SSH key already exists. Skipping..."
fi

# ----------------------------
# 🔏 GPG Key Setup for Git Signing (Ask User)
# ----------------------------

if [[ -z "$GPG_KEY_GIT" ]]; then
    read -r -p "Would you like to use GPG for signing Git commits? (y/n): " ADD_GPG_TO_GIT < /dev/tty
    if [[ "$ADD_GPG_TO_GIT" =~ ^[Yy]$ ]]; then
        GPG_KEY_GIT=$(ensure_gpg_key "Git Commit Signing")
        printf "🔐 Configuring Git to use GPG key for signing...\n"
        cat <<EOF >> "/home/$USERNAME/.gitconfig-user"

[commit]
    gpgSign = true

[gpg]
    program = gpg

[user]
    signingKey = $GPG_KEY_GIT
EOF

        chown "$USERNAME:$USERNAME" "/home/$USERNAME/.gitconfig-user"

        printf "📜 To retrieve your GPG key, run the following command:\n"
        printf "----------------------------------------------------\n"
        printf "gpg --armor --export %s\n" "$GPG_KEY_GIT"
        printf "----------------------------------------------------\n"
        printf "🔗 Go to GitHub: https://github.com/settings/gpg-keys\n"
        printf "🔹 Click 'New GPG Key' and paste the output of the above command.\n"
    else
        printf "⚠️ Skipping GPG signing configuration in Git.\n"
    fi
fi

# ----------------------------
# 🌐 Prompt for Brave Browser Installation
# ----------------------------
read -p "Would you like to install Brave Browser? (y/n): " BRAVE_CHOICE < /dev/tty
if [[ "$BRAVE_CHOICE" == "y" || "$BRAVE_CHOICE" == "Y" ]]; then

    # ----------------------------
    # 🔏 GPG Key Setup for Brave
    # ----------------------------
    GPG_KEY_BRAVE=$(ensure_gpg_key "Brave Browser Package Verification")

    if [[ -n "$GPG_KEY_BRAVE" ]]; then
        echo "🔑 Using GPG key ($GPG_KEY_BRAVE) for Brave package verification..."

        # Import the user's GPG key for Brave verification
        su -c "gpg --export $GPG_KEY_BRAVE | sudo pacman-key --add -" $USERNAME
        su -c "sudo pacman-key --lsign-key $GPG_KEY_BRAVE" $USERNAME
    else
        echo "⚠️ Brave requires a GPG key, but none was generated. Installation may fail."
    fi

    echo "🌍 Installing Brave Browser..."
    su -c "yay -S --noconfirm brave-bin" $USERNAME
    echo "✅ Brave Browser installed successfully."
else
    echo "⚠️ Skipping Brave Browser installation."
fi

# ----------------------------
# 🎉 Completion
# ----------------------------
echo "🎉 Setup complete! Please add your SSH and GPG keys to GitHub if you haven't already."
