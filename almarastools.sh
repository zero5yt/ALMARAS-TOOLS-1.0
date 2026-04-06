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

clean_menu() {
    clear
    tput cup 0 0
    source "$SCRIPT_DIR/logo.sh"
    
    # Define Colors
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    NC='\033[0m'
    
    # Server Status Check
    if pgrep -f "python -m http.server" > /dev/null; then
        STATUS="${GREEN}ONLINE${NC}"
    else
        STATUS="${RED}OFFLINE${NC}"
    fi

    echo -e "\n"
    echo "  [Work Folder: $BASE_DIR]"
    echo -e "  [Server Status: $STATUS]"
    echo ""
    echo "  1   Download Facebook Video"
    echo "  2   Combine Video + Audio"
    echo "  3  Convert MKV to MP4"
    echo "  4  Cut Video"
    echo "  5  Add Subtitle"
    echo "  6  Update yt-dlp"
    echo "  7  Combine M4S Video + Audio"
    echo "  8  Upload to RoderickMovies (Channel)"
    echo "  9  Upload Aby"
    echo "  10  Download Any Video (YT/FB/TikTok/Etc"
    echo "  11  Reset Login Session"
    echo "  12 Start Ngrok Server (Port 8080)"
    echo "  13 stop/start"
    echo "  0  Exit"
    echo ""
}

while true; do
    clean_menu
    # Check kung may space pa (halimbawa, kung bababa sa 500MB, titigil)
free_space=$(df /sdcard | awk 'NR==2 {print $4}')
if [ "$free_space" -lt 500000 ]; then
    echo "[!] WARNING: Low storage! Please free up space."
    read -p "Press Enter..."
fi
    read -p "Choose option: " choice

    if [ "$choice" = "1" ]; then
        read -p "Enter FB URL: " fb_url
        
        echo ""
        echo "Pumili ng Quality:"
        echo "  A. BEST QUALITY (1080p, may merge process)"
        echo "  B. STORAGE FRIENDLY (720p, direct download)"
        read -p "Type A or B: " q_choice
        
        clear
        echo "[*] Downloading, please wait..."
        
        if [ "$q_choice" = "A" ] || [ "$q_choice" = "a" ]; then
            # Command para sa 1080p (Best Quality + Merge)
            yt-dlp --restrict-filenames -f "bestvideo+bestaudio/best" --merge-output-format mp4 -o "$BASE_DIR/VIDEO_%(id)s.%(ext)s" "$fb_url"
        else
            # Command para sa 720p (Direct - No Merge)
            yt-dlp --restrict-filenames -f "best" -o "$BASE_DIR/VIDEO_%(id)s.%(ext)s" "$fb_url"
        fi
        
        echo ""
        if [ $? -eq 0 ]; then
            echo "[*] Download Successful!"
        else
            echo "[!] Download Failed!"
        fi
        read -p "Press Enter to return to menu..."
        

    elif [ "$choice" = "2" ]; then
        read -p "Video file name (nasa loob ng ATOOLS v.mp4): " v_name
        read -p "Audio file name (nasa loob ng ATOOLS a.m4a): " a_name
        ffmpeg -i "$BASE_DIR/$v_name" -i "$BASE_DIR/$a_name" -c copy "$BASE_DIR/combined.mp4"
        echo "Saved: $BASE_DIR/combined.mp4"
        read -p "Press Enter..."
        

    elif [ "$choice" = "3" ]; then
        read -p "MKV file name (nasa loob ng ATOOLS): " mkv_name
        ffmpeg -i "$BASE_DIR/$mkv_name" -c copy "$BASE_DIR/${mkv_name%.*}.mp4"
        read -p "Done! Press Enter..."
        

    elif [ "$choice" = "4" ]; then
        read -p "File name: " c_name
        read -p "Start time (HH:MM:SS): " s_time
        read -p "Duration (seconds): " dur
        ffmpeg -i "$BASE_DIR/$c_name" -ss "$s_time" -t "$dur" -c copy "$BASE_DIR/cut_video.mp4"
        read -p "Saved as cut_video.mp4. Press Enter..."
        

    elif [ "$choice" = "5" ]; then
        read -p "Video name: " v_name
        read -p "Subtitle (.srt) name: " s_name
        ffmpeg -i "$BASE_DIR/$v_name" -i "$BASE_DIR/$s_name" -c copy -c:s srt "$BASE_DIR/output_sub.mkv"
        read -p "Done! Press Enter..."
        

    elif [ "$choice" = "6" ]; then
        pip install -U yt-dlp
        read -p "Updated! Press Enter..."
        

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
        

    elif [ "$choice" = "8" ]; then
        echo "Pumili ng upload type:"
        echo "  A. Upload as VIDEO (may preview/thumbnail)"
        echo "  B. Upload as FILE (mas mabilis)"
        read -p "Type A or B: " upload_type
        read -p "Full path Copy mo To👉 /storage/emulated/0/Download/ATOOLS/Video.mp4 👈: " video_path
        read -p "Caption: " caption
        
        if [ -f "$video_path" ]; then
            clear
            echo "[*] Uploading, please wait..."
            
            # Patakbuhin ang script
            if [ "$upload_type" = "A" ] || [ "$upload_type" = "a" ]; then
                python3 "$SCRIPT_DIR/uploadvideo.py" "$video_path" "samplelangitoalmaras" "$caption"
            else
                python3 "$SCRIPT_DIR/uploadfile.py" "$video_path" "samplelangitoalmaras" "$caption"
            fi
            
            # Dito natin chine-check kung nag-error ang Python script
            if [ $? -ne 0 ]; then
                echo ""
                echo "----------------------------------------------------"
                echo " [!] UPLOAD FAILED! "
                echo " [!] Possible cause: Wrong API ID/HASH or Expired Session."
                echo " [!] SOLUTION: Go to Option 9 to RESET your LOGIN."
                echo "----------------------------------------------------"
                read -p "Press Enter to return to menu..."
            else
                read -p "Upload Successful! Press Enter..."
            fi
        else
            echo "Error: File not found."
            read -p "Press Enter to continue..."
        fi
        
        elif [ "$choice" = "9" ]; then
    echo "[a] Paste .MP4 Link"
    echo "[b] Get .MP4 from /storage/emulated/0/Download/ATOOLS/"
    read -p "Pili ka (a/b): " sub_choice

    if [ "$sub_choice" = "a" ]; then
        read -p "Enter Aby Download Link: " link_url
        bash "$SCRIPT_DIR/upload_aby.sh" "$link_url"
    
    elif [ "$sub_choice" = "b" ]; then
        TARGET_DIR="/storage/emulated/0/Download/ATOOLS"
        echo "Files sa $TARGET_DIR:"
        ls -1 "$TARGET_DIR"/*.mp4
        read -p "I-type ang filename (ex: Rampage 2018 Tagalog Dubbed.mp4): " filename
        
        # Dito natin ididikit ang path at gagamit ng quotes
        bash "$SCRIPT_DIR/upload_aby.sh" "$TARGET_DIR/$filename"
    fi
    read -p "Press Enter to continue..."

    elif [ "$choice" = "10" ]; then
        read -p "Enter URL: " url
        echo "Downloading in Best Quality (MP4)..."
        yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv+ba/b" \
               --merge-output-format mp4 \
               --add-metadata \
               -o "$BASE_DIR/%(title)s.%(ext)s" "$url"
        read -p "Download Finished! Press Enter to continue..."

    elif [ "$choice" = "11" ]; then
        clear
        rm -f user_session.session
        rm -f config_api.txt
        echo "--- LOGIN RESET SUCCESSFUL ---"
        sleep 1

    elif [ "$choice" = "12" ]; then
        clear
        echo "-- NGROK SERVER SETUP --"
        read -p "Enter Ngrok Token (Enter to skip): " token
        if [ ! -z "$token" ]; then
            ngrok config add-authtoken "$token"
            echo "[+] Token Saved!"
        fi
        cd "$BASE_DIR"
        pkill -f "python -m http.server"
        python -m http.server 8080 > /dev/null 2>&1 &
        echo "[!] Python Server running in background."
        echo -e "[!] OPEN NEW SESSION AND TYPE: ${BLUE}ngrok http 8080${NC}"
        read -p "Press Enter to return to menu..."  
elif [ "$choice" = "13" ]; then
        clear
        echo "--- SERVER MANAGER ---"
        if pgrep -f "python -m http.server" > /dev/null; then
            echo -e "${RED}[!] Server is RUNNING.${NC}"
            read -p "Stop server? (y/n): " stop_choice
            if [ "$stop_choice" = "y" ]; then
                pkill -f "python -m http.server"
                echo -e "${YELLOW}[-] Server STOPPED.${NC}"
            fi
        else
            echo -e "${BLUE}[!] Server is NOT running.${NC}"
            read -p "Start server? (y/n): " start_choice
            if [ "$start_choice" = "y" ]; then
                cd "$BASE_DIR"
                python -m http.server 8080 > /dev/null 2>&1 &
                echo -e "${YELLOW}[+] Server STARTED.${NC}"
            fi
        fi
        read -p "Press Enter to return to menu..."

    elif [ "$choice" = "0" ]; then
        exit 0
    else
        echo "Invalid option."
        sleep 1
    fi
done
