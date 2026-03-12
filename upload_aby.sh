#!/bin/bash

# --- ABYSS SETUP ---
KEY_FILE="abyss_key.txt"
FLD_ID="vwJ2zBCl5c"

# 1. Hingi ng API Key kung wala pa
if [ ! -f "$KEY_FILE" ]; then
    echo "--- ABYSS SETUP ---"
    read -p "Enter Aby API Key: " abyss_key
    echo "$abyss_key" > "$KEY_FILE"
fi

ABYSS_API_KEY=$(cat "$KEY_FILE")
URL=$1

# 2. Kunin ang original filename mula sa URL (para hindi movie.mp4 lang)
# Ang sed 's/%20/ /g' ay para palitan yung %20 (space sa URL) ng totoong space
FILENAME=$(basename "$URL" | sed 's/%20/ /g')

# 3. Download ang file gamit ang tamang pangalan
echo "Downloading $FILENAME..."
wget -O "$FILENAME" "$URL"

# 4. Upload sa Abyss gamit ang tamang filename
if [ -f "$FILENAME" ]; then
    echo "Uploading to Aby..."
    pv "$FILENAME" | curl -F "file=@-;filename=$FILENAME" -F "fld_id=$FLD_ID" "http://up.abyss.to/$ABYSS_API_KEY"
    
    # 5. Clean up (Burahin ang file pagkatapos ma-upload)
    rm "$FILENAME"
    echo -e "\nUpload to Aby Done!"
else
    echo "Error: Download failed."
fi
