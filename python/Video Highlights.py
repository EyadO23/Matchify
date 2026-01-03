
import json
import redis
import subprocess
from pathlib import Path

# =========================
# Redis
# =========================
r = redis.Redis(host="127.0.0.1", port=6379, decode_responses=True)

# =========================
# Paths
# =========================
PYTHON_EXE = r"C:\Users\LOQ\Desktop\Matchify Laravel\venv\Scripts\python.exe"
INFERENCE_SCRIPT = r"C:\Users\LOQ\Desktop\Matchify Laravel\python\video_ai\service\run_inference.py"

HIGHLIGHT_OUTPUT_BASE = Path(
    "C:/Users/LOQ/Desktop/Matchify Laravel/storage/app/video_ai/highlights"
)

print(" Highlight Worker running...")

# =========================
# Worker Loop
# =========================
while True:
    job = r.brpop("highlight_jobs", timeout=1)
    if not job:
        continue

    _, payload = job
    data = json.loads(payload)

    job_id       = data["job_id"]
    clips_dir    = data["clips_dir"]
    summary_type = data.get("summary_type", "goals")
    summary_len  = data.get("summary_length", "short")
    user_id      = data.get("user_id")

    try:
        # =========================
        # Init job status
        # =========================
        r.set(f"job:{job_id}:status", "processing")
        r.set(f"job:{job_id}:stage", "loading_model")
        r.set(f"job:{job_id}:progress", 5)

        # =========================
        # Output directory
        # =========================
        highlight_dir = HIGHLIGHT_OUTPUT_BASE / str(job_id)
        highlight_dir.mkdir(parents=True, exist_ok=True)

        # =========================
        # Run inference (بدون --output_dir)
        # =========================
        process = subprocess.Popen(
            [
                PYTHON_EXE,
                INFERENCE_SCRIPT,
                f"--clips_dir={clips_dir}",
                f"--summary_type={summary_type}",
                f"--summary_length={summary_len}",
                f"--job_id={job_id}",
            ],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )

        stdout, stderr = process.communicate()

        if process.returncode != 0:
            raise RuntimeError(stderr)

        # =========================
        # Save result (relative path for Laravel)
        # =========================
        result = {
            "job_id": job_id,
            "user_id": user_id,
            "clips_dir": clips_dir,  # ✅ مهم لحفظه في DB
            "summary_type": summary_type,
            "summary_length": summary_len,
            "video_path": f"video_ai/highlights/{job_id}/highlight.mp4"
        }

        r.set(f"job:{job_id}:result", json.dumps(result))
        r.set(f"job:{job_id}:progress", 100)
        r.set(f"job:{job_id}:stage", "completed")
        r.set(f"job:{job_id}:status", "completed")

        print(f" Highlight job {job_id} completed")

    except Exception as e:
        r.set(f"job:{job_id}:status", "failed")
        r.set(f"job:{job_id}:stage", "error")
        r.set(f"job:{job_id}:progress", 0)
        r.set(f"job:{job_id}:error", str(e))
        print(f" Highlight job {job_id} failed:", e)


# import sys
# import os
# import argparse
# import json
# import time
# import torch
# import cv2
# import redis
# import subprocess

# # =========================
# # Fix PYTHON PATH
# # =========================
# sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))


# from video_ai.config import *
# from video_ai.models.resnet3d import load_resnet3d
# from video_ai.models.mlp_goal import MLP
# from video_ai.pipeline.predictor import predict_clip
# from video_ai.pipeline.merge_segments import merge_windows
# from video_ai.utils.video_info import get_fps, get_video_duration

# # =========================
# # Redis connection
# # =========================
# r = redis.Redis(host="127.0.0.1", port=6379, decode_responses=True)

# def update(job_id, key, value):
#     r.set(f"job:{job_id}:{key}", value)

# # =========================
# # Load models once
# # =========================
# def load_models(job_id):
#     update(job_id, "stage", "loading model")
#     update(job_id, "progress", 5)

#     resnet = load_resnet3d(DEVICE)
#     clf = MLP().to(DEVICE)
#     clf.load_state_dict(torch.load(MODEL_PATH, map_location=DEVICE))
#     clf.eval()
#     return resnet, clf

# # =========================
# # Process one clip
# # =========================
# def process_clip(video_path, resnet, clf, threshold):
#     fps = get_fps(video_path)
#     preds = predict_clip(video_path, resnet, clf, DEVICE)
#     segments = merge_windows(preds, fps, threshold, MAX_GAP)
#     return preds, segments

# # =========================
# # Create highlight video from segments
# # =========================
# def create_highlight_video(input_video, segments, output_path, margin=1.0):
#     if not segments:
#         return False

#     cap = cv2.VideoCapture(input_video)
#     fps = cap.get(cv2.CAP_PROP_FPS)
#     width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
#     height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

#     out = cv2.VideoWriter(
#         output_path,
#         cv2.VideoWriter_fourcc(*"mp4v"),
#         fps,
#         (width, height)
#     )

#     frames_to_keep = set()
#     for start, end in segments:
#         s = max(int((start - margin) * fps), 0)
#         e = int((end + margin) * fps) + 1
#         frames_to_keep.update(range(s, e))

#     idx = 0
#     while True:
#         ret, frame = cap.read()
#         if not ret:
#             break
#         if idx in frames_to_keep:
#             out.write(frame)
#         idx += 1

#     cap.release()
#     out.release()
#     return True

# # =========================
# # Merge videos using ffmpeg
# # =========================
# def merge_videos_ffmpeg(video_files, output_path):
#     if not video_files:
#         return False

#     # إنشاء ملف txt مؤقت للفيديوهات
#     list_file = os.path.join(os.path.dirname(output_path), "clips_list.txt")
#     with open(list_file, "w") as f:
#         for vf in video_files:
#             f.write(f"file '{vf}'\n")

#     cmd = [
#         "ffmpeg", "-y", "-f", "concat", "-safe", "0",
#         "-i", list_file, "-c", "copy", output_path
#     ]
#     subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
#     os.remove(list_file)
#     return True

# # =========================
# # MAIN
# # =========================
# if __name__ == "__main__":
#     parser = argparse.ArgumentParser()
#     parser.add_argument("--clips_dir", required=True)
#     parser.add_argument("--job_id", required=True)
#     parser.add_argument("--summary_type", type=str, default="goals", choices=["goals", "cards"])
#     parser.add_argument("--summary_length", type=str, default="short", choices=["short", "long"])
#     args = parser.parse_args()

#     CLIPS_DIR = args.clips_dir
#     JOB_ID = args.job_id
#     SUMMARY_TYPE = args.summary_type
#     SUMMARY_LENGTH = args.summary_length

#     OUTPUT_DIR = os.path.join("C:/Users/LOQ/Desktop/Matchify Laravel/python/temp_videos")
#     os.makedirs(OUTPUT_DIR, exist_ok=True)
#     FINAL_HIGHLIGHT = os.path.join(OUTPUT_DIR, f"{JOB_ID}.mp4")

#     THRESHOLD = 0.5  # ثابت أو حسب النوع والطول

#     update(JOB_ID, "status", "processing")
#     update(JOB_ID, "stage", "starting inference")
#     update(JOB_ID, "progress", 1)

#     start_time = time.time()
#     resnet, clf = load_models(JOB_ID)

#     clips = [f for f in os.listdir(CLIPS_DIR) if f.endswith(".mp4")]
#     total = len(clips)

#     all_segments = []
#     temp_clip_paths = []
#     selected_duration = 0.0
#     total_duration = 0.0

#     for i, clip in enumerate(clips):
#         update(JOB_ID, "stage", f"processing {clip}")
#         progress = int(((i + 1) / total) * 90) + 5
#         update(JOB_ID, "progress", progress)

#         path = os.path.join(CLIPS_DIR, clip)
#         duration = get_video_duration(path)
#         total_duration += duration

#         preds, segments = process_clip(path, resnet, clf, THRESHOLD)

#         # جمع كل الـ segments
#         for seg in segments:
#             all_segments.append(seg)
#             selected_duration += seg[1] - seg[0]

#         # حفظ كل clip مؤقت للدمج
#         temp_output = os.path.join(OUTPUT_DIR, f"clip_{i}.mp4")
#         if segments:
#             create_highlight_video(path, segments, temp_output)
#             temp_clip_paths.append(temp_output)

#     # دمج كل المقاطع في الفيديو النهائي
#     merge_videos_ffmpeg(temp_clip_paths, FINAL_HIGHLIGHT)

#     end_time = time.time()

#     result_json = {
#         "success": True,
#         "status": "completed",
#         "progress": 100,
#         "result": {
#             "job_id": JOB_ID,
#             "user_id": 1,
#             "clips_dir": CLIPS_DIR,
#             "summary_type": SUMMARY_TYPE,
#             "summary_length": SUMMARY_LENGTH,
#             "video_path": FINAL_HIGHLIGHT,
#             "total_duration_sec": round(total_duration, 2),
#             "segments": [[round(s[0], 2), round(s[1], 2)] for s in all_segments],
#             "audio_stats": {
#                 "threshold": THRESHOLD,
#                 "num_segments": len(all_segments)
#             },
#             "video_stats": {
#                 "num_clips": len(clips),
#                 "selected_duration_sec": round(selected_duration, 2)
#             },
#             "time_reduction_factor": round(total_duration / selected_duration, 2) if selected_duration > 0 else 1.0,
#             "processing_time_sec": round(end_time - start_time, 2),
#             "clips": [os.path.join("storage/processed_videos", str(JOB_ID), f"clip_{i}.mp4") for i in range(len(temp_clip_paths))]
#         }
#     }

#     update(JOB_ID, "progress", 100)
#     update(JOB_ID, "status", "done")
#     update(JOB_ID, "stage", "finished")
#     update(JOB_ID, "result", json.dumps(result_json))

#     print(f"[INFO] Highlight video processed. JSON ready for job {JOB_ID}")
