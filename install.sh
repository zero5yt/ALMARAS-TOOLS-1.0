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
pkg install -y git python ffmpeg ncurses-utils pv

# 3. Setup Storage (para makapag-save sa /sdcard/Download)
echo "[*] Setting up storage..."
termux-setup-storage

# 4. Upgrade pip at install ng Python libraries
echo "[*] Installing python libraries..."

pip install -U yt-dlp telethon

# 5. Gawing executable ang scripts
echo "[*] Setting permissions..."
chmod +x almarastools.sh
chmod +x logo.sh

echo ""
echo "=========================================="
echo "         INSTALLATION COMPLETE!          "
echo "=========================================="
echo "Run the tool using:"
echo "bash almarastools.sh"
echo "=========================================="
