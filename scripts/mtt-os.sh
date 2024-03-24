#!/bin/bash
#
# mtt-os.sh
# Purpose:  Fedora Linux 38 Restore Script
# Author:   Marcus T Taylor
# Created:  29.06.23
# Updated:  02.09.23


## First, add a few special repos...

# Brave browser specific stuff...
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
# gh specific stuff
sudo dnf install 'dnf-command(config-manager)'
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
# Nvidia
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm    # steam reposudo 
# Visual Studio Code
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf copr enable frostyx/qtile  # qtile
sudo dnf copr enable zawertun/hack-fonts  # hack-font repo

# But first, a quick update of package repos...
sudo dnf upgrade --refresh
sudo dnf check-update


## Begin installing my favorite packages
sudo dnf install dnf-plugins-core \
    black \
    brave-browser brave-keyring \
    dunst \
    git \
    gh \
    lxapperance \
    kitty \
    akmod-nvidia \
    picom \
    python-flask \
    python-requests \
    qtile \
    qtile-extras \
    slick-greeter \
    steam \
    code \
    vim \
    xfce4-power-manager \
    yaru-theme

# Fonts
sudo dnf install \
    dejavu-fonts-all \
    fira-code-fonts \
    fontawesome-fonts \
    google-noto-fonts-common \
    google-roboto-fonts \
    hack-fonts \
    jetbrains-mono-fonts \
    liberation-fonts \
    linux-libertine-fonts \
    open-sans-fonts

# Cleanup
sudo dnf remove firefox # Drop that nonsense
sudo dnf group remove gnome-desktop-environment # Remove GNOME
sudo dnf remove nano    # Drop that nonsense
sleep 2


## Config files!

# Bash
echo "Downloading .bashrc from GitHub repo..."
cd ~
curl -O https://raw.githubusercontent.com/mtttech/dotfiles/master/bashrc
mv bashrc .bashrc
echo "Download complete."
sleep 2

# kitty
KITTY_DIR=~/.config/kitty
if [ ! -d $KITTY_DIR ]; then
    mkdir $KITTY_DIR
    echo "Created kitty config directory."
fi

while true
do
    read -p "Download kitty.conf from GitHub repo? [y/n] " yes_no
    if [ $yes_no == "y" ]; then
        echo "Downloading kitty.conf from GitHub repo..."
        cd $KITTY_DIR
        curl -O https://raw.githubusercontent.com/mtttech/dotfiles/master/kitty/kitty.conf
        cd ~
        echo "Download complete."
        break
    elif [ $yes_no == "n" ]; then
        echo "Download aborted."
        break
    fi
done
sleep 2

# Git
cd ~
curl -O https://raw.githubusercontent.com/mtttech/dotfiles/master/gitconfig
mv gitconfig .gitconfig
# Get the latest gh client...
sleep 2

# Vim
cd ~
curl -O https://raw.githubusercontent.com/mtttech/dotfiles/master/vimrc
mv vimrc .vimrc
sleep 2

# Create qtile config directory, (if necessary).
QTILE_DIR=~/.config/qtile
if [ ! -d $QTILE_DIR ]; then
    mkdir $QTILE_DIR
    echo "Created qtile config directory."
fi

cd $QTILE_DIR
curl -O https://raw.githubusercontent.com/mtttech/dotfiles/master/qtile/config.py
QTILE_AUTO_START_DIR=$(QTILE_DIR)/scripts
if [ ! -d $QTILE_AUTO_START_DIR ]; then
    mkdir $QTILE_AUTO_START_DIR
fi
cd $QTILE_AUTO_START_DIR
curl -O https://raw.githubusercontent.com/mtttech/dotfiles/master/qtile/scripts/autostart.sh
cd ~
sleep 2
