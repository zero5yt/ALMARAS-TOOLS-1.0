#!/bin/bash

# Clear screen para malinis ang simula
clear

echo "=========================================="
echo "      INSTALLING ALMARAS TOOLS V1.0      "
echo "=========================================="
echo ""

# 1. Update at Upgrade ng system
echo "[*] Updating system..."
pkg update -y && pkg upgrade -y

# 2. Install ng mga kailangang packages (ncurses-utils = tput, pv = animation)
echo "[*] Installing required packages..."

pkg install -y git python ffmpeg ncurses-utils pv curl wget

# 2.5 Download at Setup Ngrok
echo "[*] Installing Ngrok..."
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz
tar -xvzf ngrok-v3-stable-linux-arm64.tgz
chmod +x ngrok
mv ngrok $PREFIX/bin/
rm ngrok-v3-stable-linux-arm64.tgz

# 3. Setup Storage (para makapag-save sa /sdcard/Download)
echo "[*] Setting up storage..."
termux-setup-storage

# 4. Upgrade pip at install ng Python libraries
echo "[*] Installing python libraries..."

pip install -U yt-dlp telethon

# 5. Gawing executable ang lahat ng scripts
echo "[*] Setting up permissions..."
chmod +x almarastools.sh
chmod +x logo.sh
chmod +x upload_aby.sh
# Ang mga .py ay hindi kailangan ng chmod +x, pero okay lang na i-add

echo ""
echo "=========================================="
echo "     INSTALLATION COMPLETE COPY TO RUN!          "
echo "=========================================="
echo "Run the tool using:"
echo "bash almarastools.sh"
echo "./almarastools.sh"
echo "=========================================="
