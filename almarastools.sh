#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# Default Folder Path
BASE_DIR="/sdcard/Download/ATOOLS"

# Check kung na-setup ang storage, kung hindi, babalaan ang user
if [ ! -d "/sdcard/Download" ]; then
    echo "============================================"
    echo "  NOTE: Ka Streamix Kailangan mo munang i-run ang:"
    echo "  'termux-setup-storage'"
    echo "  sa iyong Termux bago gamitin ang tools."
    echo "============================================"
    exit 1
fi

# Auto-create ang folder
mkdir -p "$BASE_DIR"
clean_menu() {
    clear
    tput cup 0 0
    source "$SCRIPT_DIR/logo.sh"
    echo -e "\n"
}
    echo "  [Work Folder: $BASE_DIR]"
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

    if [ "$choice" = "1" ]; then
        read -p "Enter FB URL: " fb_url
        yt-dlp -o "$BASE_DIR/%(title)s.%(ext)s" "$fb_url"
        read -p "Press Enter..."
        clean_menu

    elif [ "$choice" = "2" ]; then
        read -p "Video file name (nasa loob ng ATOOLS): " v_name
        read -p "Audio file name (nasa loob ng ATOOLS): " a_name
        ffmpeg -i "$BASE_DIR/$v_name" -i "$BASE_DIR/$a_name" -c copy "$BASE_DIR/combined.mp4"
        echo "Saved: $BASE_DIR/combined.mp4"
        read -p "Press Enter..."
        clean_menu

    elif [ "$choice" = "3" ]; then
        read -p "MKV file name (nasa loob ng ATOOLS): " mkv_name
        ffmpeg -i "$BASE_DIR/$mkv_name" -c copy "$BASE_DIR/${mkv_name%.*}.mp4"
        read -p "Done! Press Enter..."
        clean_menu

    elif [ "$choice" = "4" ]; then
        read -p "File name: " c_name
        read -p "Start time (HH:MM:SS): " s_time
        read -p "Duration (seconds): " dur
        ffmpeg -i "$BASE_DIR/$c_name" -ss "$s_time" -t "$dur" -c copy "$BASE_DIR/cut_video.mp4"
        read -p "Saved as cut_video.mp4. Press Enter..."
        clean_menu

    elif [ "$choice" = "5" ]; then
        read -p "Video name: " v_name
        read -p "Subtitle (.srt) name: " s_name
        ffmpeg -i "$BASE_DIR/$v_name" -i "$BASE_DIR/$s_name" -c copy -c:s srt "$BASE_DIR/output_sub.mkv"
        read -p "Done! Press Enter..."
        clean_menu

    elif [ "$choice" = "6" ]; then
        pip install -U yt-dlp
        read -p "Updated! Press Enter..."
        clean_menu

    elif [ "$choice" = "7" ]; then
        read -p "Folder name (nasa loob ng ATOOLS): " sub_folder
        video_file="$BASE_DIR/$sub_folder/video.m4s"
        audio_file="$BASE_DIR/$sub_folder/audio.m4s"
        if [ -f "$video_file" ] && [ -f "$audio_file" ]; then
            ffmpeg -i "$video_file" -i "$audio_file" -c copy "$BASE_DIR/$sub_folder/final.mp4"
            echo "Success! Saved in $sub_folder/final.mp4"
        else
            echo "Error: Hindi mahanap ang video.m4s/audio.m4s sa $sub_folder"
        fi
        read -p "Press Enter..."
        clean_menu

    elif [ "$choice" = "8" ]; then
        echo "Pumili ng upload type:"
        echo "  A. Upload as VIDEO (may preview/thumbnail)"
        echo "  B. Upload as FILE (mas mabilis)"
        read -p "Type A or B: " upload_type
        read -p "Full path Copy mo To👉 /sdcard/Download/ATOOLS/videonamemo.mp4 👈: " video_path
        read -p "Caption: " caption
        
        if [ -f "$video_path" ]; then
            if [ "$upload_type" = "A" ] || [ "$upload_type" = "a" ]; then
                python3 "$SCRIPT_DIR/uploadvideo.py" "$video_path" "samplelangitoalmaras" "$caption"
            else
                python3 "$SCRIPT_DIR/uploadfile.py" "$video_path" "samplelangitoalmaras" "$caption"
            fi
        else
            echo "Error: File not found."
        fi
        read -p "Press Enter to continue..."
        clean_menu

        elif [ "$choice" = "9" ]; then
        clear
        echo "--- RESET SYSTEM ---"
        echo "1. Reset Login Session Only (Keep API ID/Hash)"
        echo "2. Full Factory Reset (Delete API ID/Hash & Session)"
        read -p "Select option (1 or 2): " reset_choice
        
        if [ "$reset_choice" = "1" ]; then
            rm -f user_session.session
            echo "Session reset. You will only re-login via OTP."
        elif [ "$reset_choice" = "2" ]; then
            rm -f user_session.session
            rm -f config_api.txt
            echo "Full Reset! You will re-enter API ID/Hash and login."
        else
            echo "Invalid choice."
        fi
        
        sleep 2
        clean_menu

    elif [ "$choice" = "0" ]; then
        exit 0
    fi
done
