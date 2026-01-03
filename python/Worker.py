

# import json
# import redis
# import signal
# import sys
# from pathlib import Path
# from pipeline import process_video_highlights

# # =========================
# # Redis connection
# # =========================
# r = redis.Redis(host="127.0.0.1", port=6379, decode_responses=True)

# # =========================
# # Base directory
# # =========================
# BASE_CLIPS_DIR = Path("C:/Users/LOQ/Desktop/Matchify Laravel/storage/app/video_ai/clips")

# running = True

# def stop_worker(signum, frame):
#     global running
#     print("\n🛑 Audio Worker stopping...")
#     running = False

# signal.signal(signal.SIGINT, stop_worker)
# signal.signal(signal.SIGTERM, stop_worker)

# print("🎬 Audio / Video Worker running...")

# while running:
#     try:
#         job = r.brpop("video_filter_jobs", timeout=1)
#         if not job:
#             continue

#         _, payload = job
#         data = json.loads(payload)

#         job_id = data["job_id"]
#         video_path = data["video_path"]

#         print(f"🎬 Processing job {job_id}")

#         try:
#             # =========================
#             # Correct output directory
#             # =========================
#             clips_dir = BASE_CLIPS_DIR / f"job_{job_id}"
#             clips_dir.mkdir(parents=True, exist_ok=True)
#             clips_dir_str = str(clips_dir.resolve())  # force absolute path

#             # =========================
#             # Update Redis
#             # =========================
#             r.set(f"job:{job_id}:status", "processing")
#             r.set(f"job:{job_id}:stage", "extracting_clips")
#             r.set(f"job:{job_id}:progress", 20)

#             # =========================
#             # Process video
#             # =========================
#             result = process_video_highlights(
#                 video_path=str(Path(video_path).resolve()),  # force absolute path
#                 output_dir=clips_dir_str
#             )

#             # =========================
#             # Normalize clip paths for DB / front-end
#             # =========================
#             clip_paths = [
#                 f"storage/video_ai/clips/job_{job_id}/{Path(p).name}"
#                 for p in result.get("clips", [])
#             ]
#             result["clips"] = clip_paths
#             result["clips_dir"] = clips_dir_str

#             # =========================
#             # Save result
#             # =========================
#             r.set(f"job:{job_id}:status", "completed")
#             r.set(f"job:{job_id}:progress", 100)
#             r.set(f"job:{job_id}:result", json.dumps(result))

#             print(f"✅ Audio job {job_id} completed")

#         except Exception as e:
#             r.set(f"job:{job_id}:status", "failed")
#             r.set(f"job:{job_id}:error", str(e))
#             print(f"❌ Audio job {job_id} failed:", e)

#     except Exception as e:
#         print("⚠️ Worker error:", e)

# print("✅ Audio Worker stopped cleanly")
# sys.exit(0)


import json
import redis
import signal
import sys
from pathlib import Path
from pipeline import process_video_highlights

# =========================
# Redis connection
# =========================
r = redis.Redis(host="127.0.0.1", port=6379, decode_responses=True)

running = True

def stop_worker(signum, frame):
    global running
    print("\n Audio Worker stopping...")
    running = False

signal.signal(signal.SIGINT, stop_worker)
signal.signal(signal.SIGTERM, stop_worker)

print(" Audio / Video Worker running...")

while running:
    try:
        job = r.brpop("video_filter_jobs", timeout=1)
        if not job:
            continue

        _, payload = job
        data = json.loads(payload)

        job_id = data["job_id"]
        video_path = data["video_path"]
        clips_dir_str = data["output_clips_dir"]

        print(f" Processing job {job_id}")

        try:
            # =========================
            # Ensure output directory exists
            # =========================
            clips_dir = Path(clips_dir_str)
            clips_dir.mkdir(parents=True, exist_ok=True)

            # =========================
            # Update Redis
            # =========================
            r.set(f"job:{job_id}:status", "processing")
            r.set(f"job:{job_id}:stage", "extracting_clips")
            r.set(f"job:{job_id}:progress", 20)

            # =========================
            # Process video
            # =========================
            result = process_video_highlights(
                video_path=str(Path(video_path).resolve()),
                output_dir=str(clips_dir.resolve())
            )

            # =========================
            # Normalize clip paths
            # =========================
            clip_paths = [
                f"storage/video_ai/clips/job_{job_id}/{Path(p).name}"
                for p in result.get("clips", [])
            ]
            result["clips"] = clip_paths
            result["clips_dir"] = str(clips_dir.resolve())

            # =========================
            # Save result
            # =========================
            r.set(f"job:{job_id}:status", "completed")
            r.set(f"job:{job_id}:progress", 100)
            r.set(f"job:{job_id}:result", json.dumps(result))

            print(f" Audio job {job_id} completed")

        except Exception as e:
            r.set(f"job:{job_id}:status", "failed")
            r.set(f"job:{job_id}:error", str(e))
            print(f" Audio job {job_id} failed:", e)

    except Exception as e:
        print(" Worker error:", e)

print(" Audio Worker stopped cleanly")
sys.exit(0)

