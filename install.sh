#!/bin/bash

clear
echo "Installing ALMARAS TOOLS..."

# I-update ang system
pkg update -y && pkg upgrade -y

pkg install -y git python ffmpeg ncurses-utils pv

# I-upgrade ang pip at i-install ang yt-dlp
pip install --upgrade pip
pip install -U yt-dlp

# I-setup ang storage
termux-setup-storage

# Gawing executable ang files
chmod +x almarastools.sh
chmod +x logo.sh

echo ""
echo "Installation complete!"
echo ""
echo "Run the tool using:"
echo "bash almarastools.sh"
