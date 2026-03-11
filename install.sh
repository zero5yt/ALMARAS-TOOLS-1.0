#!/bin/bash

clear
echo "Installing ALMARAS TOOLS..."

pkg update -y
pkg upgrade -y

pkg install git python ffmpeg -y

pip install yt-dlp

termux-setup-storage

chmod +x almarastools.sh
chmod +x logo.sh

echo ""
echo "Installation complete!"
echo ""
echo "Run the tool using:"
echo "bash almarastools.sh"
