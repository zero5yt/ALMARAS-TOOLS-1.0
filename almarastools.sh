#!/bin/bash

source logo.sh

echo ""
echo "1 Download Facebook Video"
echo "2 Combine Video + Audio"
echo "3 Convert MKV to MP4"
echo "4 Cut Video"
echo "5 Add Subtitle"
echo "6 Update yt-dlp"
echo "7 Exit"
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
ffmpeg -i "$file" -c copy output.mp4
fi

if [ "$choice" = "4" ]; then
read -p "Video file: " video
read -p "Start time (00:00:00): " start
read -p "End time (00:00:00): " end
ffmpeg -ss $start -to $end -i "$video" -c copy cut_video.mp4
fi

if [ "$choice" = "5" ]; then
read -p "Video file: " video
read -p "Subtitle file (.srt): " sub
ffmpeg -i "$video" -vf subtitles="$sub" output.mp4
fi

if [ "$choice" = "6" ]; then
pip install -U yt-dlp
fi
