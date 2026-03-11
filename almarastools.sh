#!/bin/bash

# --- CONFIG LOADING ---
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

if [ -f "$SCRIPT_DIR/config.sh" ]; then
    source "$SCRIPT_DIR/config.sh"
else
    echo "Error: Wala kang config.sh file sa $SCRIPT_DIR!"
    exit 1
fi
# ----------------------

source "$SCRIPT_DIR/logo.sh"

while true; do
    echo ""
    echo "  1  Download Facebook Video"
    echo "  2  Combine Video + Audio"
    echo "  3  Convert MKV to MP4"
    echo "  4  Cut Video"
    echo "  5  Add Subtitle"
    echo "  6  Update yt-dlp"
    echo "  7  Combine M4S Video + Audio"
    echo "  8  Upload to RoderickMovies (Channel)"
    echo "  0  Exit"
    echo ""

    read -p "Choose option: " choice

    case $choice in
        1) echo "Option 1: Download Facebook Video (Logic here)" ;;
        2) echo "Option 2: Combine Video + Audio (Logic here)" ;;
        3) echo "Option 3: Convert MKV to MP4 (Logic here)" ;;
        4) echo "Option 4: Cut Video (Logic here)" ;;
        5) echo "Option 5: Add Subtitle (Logic here)" ;;
        6) echo "Option 6: Update yt-dlp (Logic here)" ;;
        
        7) 
            read -p "Enter folder path (e.g., /sdcard/Download/ATOOLS): " m4s_folder
            video_file="$m4s_folder/video.m4s"
            audio_file="$m4s_folder/audio.m4s"
            if [ -f "$video_file" ] && [ -f "$audio_file" ]; then
                echo "Combining video.m4s and audio.m4s..."
                output_name=$(basename "$m4s_folder")
                ffmpeg -i "$video_file" -i "$audio_file" -c copy "$m4s_folder/$output_name.mp4"
                echo "Success! Combined video saved as $m4s_folder/$output_name.mp4"
            else
                echo "Error: Cannot find video.m4s and/or audio.m4s."
            fi
            ;;

        8) 
            if ! command -v curl &> /dev/null; then
                echo "Installing curl..."
                pkg install curl -y
            fi
            read -p "Enter path to video file: " video_path
            read -p "Enter a Title (caption): " caption
            if [ -f "$video_path" ]; then
                echo "Uploading to RoderickMovies... Please wait."
                curl -s -X POST "https://api.telegram.org/bot$bot_token/sendVideo" \
                     -F chat_id="$channel_chat_id" \
                     -F video=@"$video_path" \
                     -F caption="$caption"
                echo -e "\nUpload command executed. Check your Telegram channel."
            else
                echo "Error: File not found at '$video_path'"
            fi
            ;;

        0) echo "Exiting..."; exit ;;
        *) echo "Invalid option, please try again." ;;
    esac
    echo "-----------------------------------"
done
