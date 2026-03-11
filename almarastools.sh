#!/bin/bash

source logo.sh

echo ""
echo "  1  Download Facebook Video"
echo "  2  Combine Video + Audio"
echo "  3  Convert MKV to MP4"
echo "  4  Cut Video"
echo "  5  Add Subtitle"
echo "  6  Update yt-dlp"
# BINAGO: Dinagdag ang bagong option 7
echo "  7  Combine M4S Video + Audio" 
# BINAGO: Inilipat ang Exit sa 0
echo "  0  Exit"
echo ""

read -p "Choose option: " choice

if [ "$choice" = "1" ]; then
  read -p "Paste Facebook Link: " link
  yt-dlp -f "hd/bestvideo+bestaudio/best" -P /sdcard/Download "$link"
fi

if [ "$choice" = "2" ]; then
  read -p "Video file: " video
  read -p "Audio file: " audio
  ffmpeg -i "$video" -i "$audio" -c copy output.mp4
fi

if [ "$choice" = "3" ]; then
  read -p "MKV file: " file
  # Kinukuha ang directory at filename para doon din i-save ang output
  output_dir=$(dirname "$file")
  output_filename=$(basename "$file" .mkv)
  ffmpeg -i "$file" -c copy "$output_dir/$output_filename.mp4"
  echo "Output saved to: $output_dir/$output_filename.mp4"
fi

if [ "$choice" = "4" ]; then
  read -p "Video file: " video
  read -p "Start time (00:00:00): " start
  read -p "End time (00:00:00): " end
  ffmpeg -ss "$start" -to "$end" -i "$video" -c copy cut_video.mp4
fi

if [ "$choice" = "5" ]; then
  read -p "Video file: " video
  read -p "Subtitle file (.srt): " sub
  ffmpeg -i "$video" -vf subtitles="$sub" output.mp4
fi

if [ "$choice" = "6" ]; then
  pip install -U yt-dlp
fi

# DITO IDINAGDAG ANG BAGONG CODE PARA SA OPTION 7
if [ "$choice" = "7" ]; then
  read -p "Enter folder path (e.g., /sdcard/Download/ATOOLS): " m4s_folder
  
  video_file="$m4s_folder/video.m4s"
  audio_file="$m4s_folder/audio.m4s"

  # Tinitingnan kung may video.m4s at audio.m4s sa folder
  if [ -f "$video_file" ] && [ -f "$audio_file" ]; then
    echo "Combining video.m4s and audio.m4s..."
    # Ang output file ay ipapangalan base sa pangalan ng folder at ise-save sa loob din nito
    output_name=$(basename "$m4s_folder")
    ffmpeg -i "$video_file" -i "$audio_file" -c copy "$m4s_folder/$output_name.mp4"
    echo "Success! Combined video saved as $m4s_folder/$output_name.mp4"
  else
    echo "Error: Cannot find video.m4s and/or audio.m4s in the specified folder."
  fi
fi

# DITO IDINAGDAG ANG BAGONG CODE PARA SA EXIT
if [ "$choice" = "0" ]; then
  echo "Exiting..."
  exit
fi
