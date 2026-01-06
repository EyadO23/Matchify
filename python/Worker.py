import json
import redis
import signal
import sys
from pathlib import Path
from pipeline import process_video_highlights  # سكريبتك لمعالجة الفيديوهات

# =========================
# Redis connection
# =========================
r = redis.Redis(host="127.0.0.1", port=6379, decode_responses=True)

running = True

def stop_worker(signum, frame):
    global running
    print("\nVideo Worker stopping...")
    running = False

signal.signal(signal.SIGINT, stop_worker)
signal.signal(signal.SIGTERM, stop_worker)

print(" Video Worker running...")

while running:
    try:
        # =========================
        # اقرأ job من قائمة video_jobs
        # =========================
        job = r.brpop("video_jobs", timeout=1)
        if not job:
            continue

        _, payload = job
        data = json.loads(payload)

        job_id = data["job_id"]
        video_path = data["video_path"]
        clips_dir_str = data["clips_dir"]
        summary_type = data.get("summary_type")
        summary_length = data.get("summary_length")
        user_id = data.get("user_id")

        print(f"Processing video job {job_id}")

        try:
            # =========================
            # تأكد من وجود مجلد الخرج
            # =========================
            clips_dir = Path(clips_dir_str)
            clips_dir.mkdir(parents=True, exist_ok=True)

            # =========================
            # تحديث حالة المعالجة في Redis
            # =========================
            r.set(f"job:{job_id}:status", "processing")
            r.set(f"job:{job_id}:progress", 0)

            # =========================
            # معالجة الفيديو
            # =========================
            result = process_video_highlights(
                video_path=str(Path(video_path).resolve()),
                output_dir=str(clips_dir.resolve()),
                summary_type=summary_type,
                summary_length=summary_length
            )

            # =========================
            # تحديث progress تدريجيًا أثناء المعالجة
            # هنا مثال، يمكن تعديل داخل pipeline حسب تقدم المعالجة
            # =========================
            # r.set(f"job:{job_id}:progress", 50)  # يمكن تحديثها ديناميكياً

            # =========================
            # Normalize clip paths لتخزينها
            # =========================
            clip_paths = [
                f"app/public/video_ai/clips/job_{job_id}/{Path(p).name}"
                for p in result.get("clips", [])
            ]
            result["clips"] = clip_paths
            result["clips_dir"] = str(clips_dir.resolve())
            result["summary_type"] = summary_type
            result["summary_length"] = summary_length
            result["user_id"] = user_id

            # =========================
            # حفظ النتيجة في Redis
            # =========================
            r.set(f"job:{job_id}:status", "completed")
            r.set(f"job:{job_id}:progress", 100)
            r.set(f"job:{job_id}:result", json.dumps(result))

            print(f"Video job {job_id} completed")

        except Exception as e:
            r.set(f"job:{job_id}:status", "failed")
            r.set(f"job:{job_id}:error", str(e))
            print(f"Video job {job_id} failed:", e)

    except Exception as e:
        print("Worker error:", e)

print("Video Worker stopped cleanly")
sys.exit(0)



