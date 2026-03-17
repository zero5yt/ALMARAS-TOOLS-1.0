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
TARGET=$1

# 3. Check kung local file ba o URL ang pinasa
if [ -f "$TARGET" ]; then
    # Kung File sa folder
    FILENAME=$(basename "$TARGET")
    FILE_PATH="$TARGET"
    echo "Using local file: $FILENAME"
else
    # Kung URL (Download muna)
    FILENAME=$(basename "$TARGET" | sed 's/%20/ /g')
    FILE_PATH="$FILENAME"
    echo "Downloading $FILENAME..."
    wget -O "$FILENAME" "$TARGET"
fi

# 4. Upload sa Aby
if [ -f "$FILE_PATH" ]; then
    echo "Uploading to Aby..."
# Ito ay kukuha ng file, dadaan sa pv (para sa bar), at ipapasa sa curl
pv "$FILE_PATH" | curl -F "file=@-;filename=$FILENAME;type=video/mp4" -F "fld_id=$FLD_ID" "http://up.abyss.to/$ABYSS_API_KEY"    

 
    # 5. Clean up (Burahin lang kung hindi ito galing sa ATOOLS folder)
    if [[ "$FILE_PATH" != /storage/emulated/0/Download/ATOOLS/* ]]; then
        rm "$FILE_PATH"
    fi
    echo -e "\nUpload to Aby Done!"
else
    echo "Error: File/Download failed."
fi
