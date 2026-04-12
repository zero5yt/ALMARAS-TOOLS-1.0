#!/bin/bash

# --- STREAMTAPE SMART SETUP ---
LOGIN_FILE="st_login.txt"
KEY_FILE="st_key.txt"

if [ ! -f "$LOGIN_FILE" ]; then
    echo "--- STREAMTAPE FIRST TIME SETUP ---"
    read -p "Enter Streamtape API Login (ex: 48990...): " st_login
    echo "$st_login" > "$LOGIN_FILE"
fi

if [ ! -f "$KEY_FILE" ]; then
    read -p "Enter Streamtape API Key: " st_key
    echo "$st_key" > "$KEY_FILE"
fi

ST_USER=$(cat "$LOGIN_FILE")
ST_KEY=$(cat "$KEY_FILE")
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

echo -e "\nStep 1: Requesting Upload Server..."
GET_URL=$(curl -s "https://api.streamtape.com/file/ul?login=$ST_USER&key=$ST_KEY")
UPLOAD_URL=$(echo $GET_URL | jq -r '.result.url')

if [ "$UPLOAD_URL" == "null" ] || [ -z "$UPLOAD_URL" ]; then
    echo "Error: Check API Key/Login."
    rm -f "$LOGIN_FILE" "$KEY_FILE"
    exit 1
fi

echo -e "Step 2: Uploading Video: $FILENAME..."

# --- FIXED LOADING BAR (ABY STYLE BUT SOLID) ---
TEMP_RESP="st_response.json"

# Iniba natin ang pipe. Gagamit tayo ng 2>&1 para siguradong flushed ang output
# at makikita mo yung loading bar na tumatakbo (████).
curl -# -F "file1=@$FILE_PATH" "$UPLOAD_URL" -o "$TEMP_RESP" 2>&1 | tr '#' '█'

# Basahin ang link
RESPONSE=$(cat "$TEMP_RESP")
FILE_URL=$(echo $RESPONSE | jq -r '.result.url')
rm -f "$TEMP_RESP"

# --- PAG-DISPLAY NG RESULTA ---
if [ "$FILE_URL" != "null" ] && [ ! -z "$FILE_URL" ]; then
    echo -e "\n\e[1;32m[✔] Upload Success!\e[0m"
    echo -e "--------------------------------------"
    echo -e "File Link: \e[1;34m$FILE_URL\e[0m"
    echo -e "--------------------------------------"
else
    echo -e "\n[!] Upload Done pero may error sa link."
    echo "Server Response: $RESPONSE"
fi

if [ "$TARGET" != "$FILE_PATH" ]; then
    rm -f "$FILE_PATH"
fi
