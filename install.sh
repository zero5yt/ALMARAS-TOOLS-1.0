#!/bin/bash

# Clear screen para malinis ang simula
clear

echo "========================================="
echo "       INSTALLING ALMARAS TOOLS V1.0      "
echo "========================================="
echo ""

# 1. Update at Upgrade ng system
echo "[*] Updating system..."
pkg update -y && pkg upgrade -y

# 2. Install ng mga kailangang packages (Idinagdag ang procps para sa pgrep/pkill)
echo "[*] Installing required packages..."
pkg install -y git python ffmpeg ncurses-utils pv curl wget procps

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

# Gumawa ng ATOOLS folder para sigurado na may pagsasave-an ng files
echo "[*] Creating ATOOLS workspace folder..."
mkdir -p /sdcard/Download/ATOOLS

# 4. Upgrade pip at install ng Python libraries
# Gagamit ng fallback sakaling kailanganin ang --break-system-packages
echo "[*] Installing python libraries..."
pip install -U yt-dlp telethon --break-system-packages 2>/dev/null || pip install -U yt-dlp telethon

# 5. Gawing executable ang LAHAT ng .sh scripts sa folder
echo "[*] Setting up permissions..."
chmod +x *.sh

echo ""
echo "========================================="
echo "     INSTALLATION COMPLETE COPY TO RUN!  "
echo "========================================="
echo "Run the tool using:"
echo "bash almarastools.sh"
echo "or ./almarastools.sh"
echo "========================================="
