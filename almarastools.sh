#!/bin/bash

# --- CONFIG LOADING ---
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
if [ -f "$SCRIPT_DIR/config.sh" ]; then
    source "$SCRIPT_DIR/config.sh"
else
    echo "Error: config.sh not found!"
    exit 1
fi
# ----------------------

while true; do
    source "$SCRIPT_DIR/logo.sh"
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

    elif [ "$choice" = "1" ]; then
        read -p "Enter Facebook Video URL: " fb_url
        read -p "Enter Download folder path (e.g., /sdcard/Download/ATOOLS): " dl_folder
        
        # Gawin ang folder kung wala pa
        mkdir -p "$dl_folder"
        
        echo "Downloading to $dl_folder..."
        # I-download gamit ang title ng video at lagay sa specific folder
        yt-dlp -o "$dl_folder/%(title)s.%(ext)s" "$fb_url"
        
        echo "Download finished!"
        read -p "Press Enter to continue..."
        
    elif [ "$choice" = "2" ]; then
        read -p "Enter Video file path: " v_path
        read -p "Enter Audio file path: " a_path
        ffmpeg -i "$v_path" -i "$a_path" -c copy output.mp4
        echo "Saved as output.mp4"
        read -p "Press Enter to continue..."
        
    elif [ "$choice" = "3" ]; then
        read -p "Enter MKV file path: " mkv_path
        ffmpeg -i "$mkv_path" -c copy "${mkv_path%.*}.mp4"
        read -p "Done! Press Enter to continue..."
        
    elif [ "$choice" = "4" ]; then
        read -p "Enter file path: " c_path
        read -p "Start time (HH:MM:SS): " s_time
        read -p "Duration (in seconds): " dur
        ffmpeg -i "$c_path" -ss "$s_time" -t "$dur" -c copy cut_output.mp4
        read -p "Saved as cut_output.mp4. Press Enter to continue..."

    elif [ "$choice" = "5" ]; then
        read -p "Enter Video path: " v_path
        read -p "Enter Subtitle (.srt) path: " s_path
        ffmpeg -i "$v_path" -i "$s_path" -c copy -c:s srt output_sub.mkv
        read -p "Done! Press Enter to continue..."
        
    elif [ "$choice" = "6" ]; then
        pip install -U yt-dlp
        echo "yt-dlp updated."
        read -p "Press Enter to continue..."
        
    elif [ "$choice" = "7" ]; then
        read -p "Enter folder path: " m4s_folder
        video_file="$m4s_folder/video.m4s"
        audio_file="$m4s_folder/audio.m4s"
        if [ -f "$video_file" ] && [ -f "$audio_file" ]; then
            output_name=$(basename "$m4s_folder")
            ffmpeg -i "$video_file" -i "$audio_file" -c copy "$m4s_folder/$output_name.mp4"
            echo "Success! Combined video saved as $m4s_folder/$output_name.mp4"
        else
            echo "Error: Files not found."
        fi
        read -p "Press Enter to continue..."

    elif [ "$choice" = "8" ]; then
        read -p "Enter path to video file: " video_path
        read -p "Enter a Title (caption): " caption
        if [ -f "$video_path" ]; then
            echo "Uploading to RoderickMovies... Please wait."
            curl -s -X POST "https://api.telegram.org/bot$bot_token/sendVideo" \
                 -F chat_id="$channel_chat_id" \
                 -F video=@"$video_path" \
                 -F caption="$caption"
            echo -e "\nUpload command executed."
        else
            echo "Error: File not found."
        fi
        read -p "Press Enter to continue..."

    elif [ "$choice" = "0" ]; then
        echo "Exiting..."
        exit 0
    else
        echo "Invalid choice."
        sleep 1
    fi
done
