#!/bin/bash

# --- ABYSS SETUP ---
KEY_FILE="abyss_key.txt"
FLD_ID="vwJ2zBCl5c"

# Siguraduhin na may pv
if ! command -v pv &> /dev/null; then
    echo "Installing pv for progress bar..."
    pkg install pv -y
fi

# 1. Hingi ng API Key
if [ ! -f "$KEY_FILE" ]; then
    read -p "Enter Aby API Key: " abyss_key
    echo "$abyss_key" > "$KEY_FILE"
fi

ABYSS_API_KEY=$(cat "$KEY_FILE")
TARGET=$1

if [ -f "$TARGET" ]; then
    FILENAME=$(basename "$TARGET")
    FILE_PATH="$TARGET"
else
    FILENAME=$(basename "$TARGET" | sed 's/%20/ /g')
    FILE_PATH="$FILENAME"
    echo "Downloading $FILENAME..."
    wget -q --show-progress -O "$FILENAME" "$TARGET"
fi

if [ -f "$FILE_PATH" ]; then
    echo "Uploading to Aby... (Please wait for server response after 100%)"
    
    # Kukuha ng size
    FILE_SIZE=$(stat -c%s "$FILE_PATH")
    
 echo -ne "Uploading Video: $FILENAME... "

curl -# -F "fld_id=$FLD_ID" \
-F "file=@$FILE_PATH;filename=$FILENAME;type=video/mp4" \
"http://up.abyss.to/$ABYSS_API_KEY" 2>&1 | tr '#' '='


echo -e "\n[✔] Data sent! Waiting for Abyss to provide the link..."     

    echo "Server Response: $RESPONSE"
 
    if [[ "$FILE_PATH" != /storage/emulated/0/Download/ATOOLS/* ]]; then
        rm "$FILE_PATH"
    fi
    echo -e "\nUpload to Aby Done!"
else
    echo "Error: File not found."
fi
