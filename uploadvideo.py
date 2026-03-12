import os
from telethon import TelegramClient
import sys
from telethon.errors import FloodWaitError
import asyncio
# --- SMART LOGIN: Hihingi ng API ID/Hash sa unang gamit ---
if not os.path.exists("config_api.txt"):
    print("--- FIRST TIME SETUP ---")
    a_id = input("Enter your API ID: ")
    a_hash = input("Enter your API Hash: ")
    with open("config_api.txt", "w") as f:
        f.write(f"{a_id}|{a_hash}")

with open("config_api.txt", "r") as f:
    data = f.read().split("|")
    api_id, api_hash = int(data[0]), data[1]

client = TelegramClient('user_session', api_id, api_hash)

def callback(current, total):
    percent = (current / total) * 100
    sys.stdout.write(f"\rUploading Video... {percent:.1f}%")
    sys.stdout.flush()

async def main():
    if len(sys.argv) < 3: return
    await client.start()
    entity = await client.get_entity(sys.argv[2])
    caption = sys.argv[3] if len(sys.argv) > 3 else ""
    
    # --- DITO ANG UPGRADED LOGIC ---
    try:
        # Subukan ang upload
        await client.send_file(entity, sys.argv[1], caption=caption, force_document=False, progress_callback=callback)
        print("\nUpload Success! ✅")
    except FloodWaitError as e:
        # Kung na-limit ni Telegram, maghihintay siya automatic
        print(f"\n[!] Telegram limit! Maghihintay ng {e.seconds} seconds...")
        await asyncio.sleep(e.seconds)
        # Mag-retry ng upload pagkatapos maghintay
        await client.send_file(entity, sys.argv[1], caption=caption, force_document=False, progress_callback=callback)
        print("\nUpload Success (After Retry)! ✅")
    except Exception as e:
        # Kung may ibang error (halimbawa: nawalan ng internet)
        print(f"\n[!] Error sa pag-upload: {e}")
if __name__ == '__main__':
    with client:
        client.loop.run_until_complete(main())
