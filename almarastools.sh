#!/bin/bash

# Ito ang dapat mong ilagay sa main script (lines 4-5)
if [ -f config.sh ]; then
    source config.sh
else
    echo "Error: Wala kang config.sh file!"
    exit 1
fi
# --------------------------------------------------

source logo.sh

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

# ... (Dito ilagay ang codes para sa options 1-6, kung meron ka) ...

if [ "$choice" = "7" ]; then
  read -p "Enter folder path (e.g., /sdcard/Download/ATOOLS): " m4s_folder
  
  video_file="$m4s_folder/video.m4s"
  audio_file="$m4s_folder/audio.m4s"

  if [ -f "$video_file" ] && [ -f "$audio_file" ]; then
    echo "Combining video.m4s and audio.m4s..."
    output_name=$(basename "$m4s_folder")
    ffmpeg -i "$video_file" -i "$audio_file" -c copy "$m4s_folder/$output_name.mp4"
    echo "Success! Combined video saved as $m4s_folder/$output_name.mp4"
  else
    echo "Error: Cannot find video.m4s and/or audio.m4s in the specified folder."
  fi
fi

# OPTION 8: UPLOAD SA CHANNEL
if [ "$choice" = "8" ]; then
  # Check kung may curl
  if ! command -v curl &> /dev/null; then
    echo "curl could not be found. Installing curl..."
    pkg install curl -y
  fi
  
  read -p "Copy mo then paste change Path And Video Name 👉 /storage/emulated/0/Download/ATOOLS/movie.mp4 👈: " video_path
  read -p "Enter a Title (optional): " Title

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
fi

if [ "$choice" = "0" ]; then
  echo "Exiting..."
  exit
fi
