# import os
# import sys
# import argparse
# import json
# import torch
# import cv2
# from pathlib import Path
# import redis
# import subprocess
# import re
# import time

# PROJECT_ROOT = r"C:\Users\LOQ\Desktop\Matchify Laravel\python"
# sys.path.append(PROJECT_ROOT)

# from video_ai.inference.model_runner import load_model, run_inference

# r = redis.Redis(host="127.0.0.1", port=6379, decode_responses=True)
# def update(job_id, key, value):
#     r.set(f"job:{job_id}:{key}", value)

# DEVICE = "cuda" if torch.cuda.is_available() else "cpu"
# GOALS_MODEL = r"C:\Users\LOQ\Desktop\Matchify Laravel\python\video_ai\weights\goal_others_classifier.pt"
# CARDS_MODEL = r"C:\Users\LOQ\Desktop\Matchify Laravel\python\video_ai\weights\cards_others_classifier.pt"

# def natural_sort(l):
#     convert = lambda text: int(text) if text.isdigit() else text.lower()
#     alphanum_key = lambda key: [convert(c) for c in re.split('([0-9]+)', key)]
#     return sorted(l, key=alphanum_key)

# def trim_segment_with_audio(input_video, start, end, output_path):
#     cmd = [
#         "ffmpeg", "-y",
#         "-i", input_video,
#         "-ss", str(max(start-0.5,0)),
#         "-to", str(end+0.5),
#         "-c:v", "libx264",
#         "-c:a", "aac",
#         "-strict", "experimental",
#         str(output_path)
#     ]
#     subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

# def create_highlight_with_audio(segments, clips_dir, output_path):
#     tmp_files = []
#     for i, (start, end, score, clip) in enumerate(segments):
#         tmp_file = f"tmp_{i}.mp4"
#         input_path = os.path.join(clips_dir, clip)
#         trim_segment_with_audio(input_path, start, end, tmp_file)
#         tmp_files.append(tmp_file)

#     with open("tmp_list.txt", "w") as f:
#         for tmp_file in tmp_files:
#             f.write(f"file '{tmp_file}'\n")

#     subprocess.run([
#         "ffmpeg", "-y",
#         "-f", "concat",
#         "-safe", "0",
#         "-i", "tmp_list.txt",
#         "-c:v", "libx264",
#         "-c:a", "aac",
#         str(output_path)
#     ])

#     for tmp_file in tmp_files:
#         os.remove(tmp_file)
#     os.remove("tmp_list.txt")

#     return True


# # =========================
# # MAIN
# # =========================
# if __name__=="__main__":
#     parser = argparse.ArgumentParser()
#     parser.add_argument("--clips_dir", required=True)
#     parser.add_argument("--job_id", required=True)
#     parser.add_argument("--video_id", required=True)

#     # ✅ التعديل 1: صار optional
#     parser.add_argument("--summary_type", required=False, default="goals")

#     args = parser.parse_args()

#     update(args.job_id, "status", "processing")
#     update(args.job_id, "stage", "loading_model")
#     update(args.job_id, "progress", 5)

#     # =========================
#     # تحديد نوع الموديل
#     # =========================
#     # ✅ التعديل 2: fallback آمن
#     summary_type_lower = (args.summary_type or "goals").lower()

#     if "card" in summary_type_lower:
#         model_type = "cards"
#     else:
#         model_type = "goals"

#     resnet, clf = load_model(DEVICE, model_type, GOALS_MODEL, CARDS_MODEL)

#     clips = [f for f in os.listdir(args.clips_dir) if f.endswith(".mp4")]
#     clips = natural_sort(clips)

#     all_segments = []

#     for i, clip in enumerate(clips):
#         update(args.job_id, "stage", f"Processing {clip}")
#         progress = int(((i+1)/len(clips))*90)+5
#         update(args.job_id,"progress",progress)

#         path = os.path.join(args.clips_dir, clip)
#         fps = cv2.VideoCapture(path).get(cv2.CAP_PROP_FPS)

#         if model_type == "cards":
#             segments = run_inference(path, resnet, clf, fps, DEVICE, model_type, threshold=0.6)
#         else:
#             segments = run_inference(path, resnet, clf, fps, DEVICE, model_type, threshold=0.5)

#         for s,e,sc in segments:
#             all_segments.append((float(s), float(e), float(sc), clip))

#     all_segments.sort(key=lambda x: (x[3], x[0]))

#     OUTPUT_DIR = Path(f"C:/Users/LOQ/Desktop/Matchify Laravel/storage/app/public/video_ai/highlights/{args.job_id}")
#     OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
#     FINAL_HIGHLIGHT = OUTPUT_DIR / "highlight.mp4"

#     create_highlight_with_audio(all_segments, args.clips_dir, FINAL_HIGHLIGHT)

#     highlights_json = []
#     for clip in clips:
#         segs = [{"start_time_sec": s, "end_time_sec": e, "confidence_score": sc} 
#                 for s,e,sc,c in all_segments if c==clip]
#         if segs:
#             highlights_json.append({
#                 "clip": clip,
#                 "segments": segs,
#                 "highlight_video": f"/storage/video_ai/highlights/{args.job_id}/highlight.mp4"
#             })

#     json_result = {
#         "success": True,
#         "status": "completed",
#         "job_id": args.job_id,
#         "video_id": args.video_id,
#         "summary_type": summary_type_lower,
#         "clips_dir": args.clips_dir,
#         "video_path": f"/storage/video_ai/highlights/{args.job_id}/highlight.mp4",
#         "highlights": highlights_json
#     }

#     update(args.job_id, "progress",100)
#     update(args.job_id, "status","completed")
#     update(args.job_id, "stage","completed")

#     print(json.dumps(json_result, ensure_ascii=False))

# print("MODEL TYPE =", model_type)


import os
import sys
import argparse
import json
import torch
import cv2
from pathlib import Path
import redis
import subprocess
import re
import time   

PROJECT_ROOT = r"C:\Users\LOQ\Desktop\Matchify Laravel\python"
sys.path.append(PROJECT_ROOT)

from video_ai.inference.model_runner import load_model, run_inference

r = redis.Redis(host="127.0.0.1", port=6379, decode_responses=True)
def update(job_id, key, value):
    r.set(f"job:{job_id}:{key}", value)

DEVICE = "cuda" if torch.cuda.is_available() else "cpu"
GOALS_MODEL = r"C:\Users\LOQ\Desktop\Matchify Laravel\python\video_ai\weights\goal_others_classifier.pt"
CARDS_MODEL = r"C:\Users\LOQ\Desktop\Matchify Laravel\python\video_ai\weights\cards_others_classifier.pt"

def natural_sort(l):
    convert = lambda text: int(text) if text.isdigit() else text.lower()
    alphanum_key = lambda key: [convert(c) for c in re.split('([0-9]+)', key)]
    return sorted(l, key=alphanum_key)

def trim_segment_with_audio(input_video, start, end, output_path):
    cmd = [
        "ffmpeg", "-y",
        "-i", input_video,
        "-ss", str(max(start-0.5,0)),
        "-to", str(end+0.5),
        "-c:v", "libx264",
        "-c:a", "aac",
        "-strict", "experimental",
        str(output_path)
    ]
    subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

def create_highlight_with_audio(segments, clips_dir, output_path):
    tmp_files = []
    for i, (start, end, score, clip) in enumerate(segments):
        tmp_file = f"tmp_{i}.mp4"
        input_path = os.path.join(clips_dir, clip)
        trim_segment_with_audio(input_path, start, end, tmp_file)
        tmp_files.append(tmp_file)

    with open("tmp_list.txt", "w") as f:
        for tmp_file in tmp_files:
            f.write(f"file '{tmp_file}'\n")

    subprocess.run([
        "ffmpeg", "-y",
        "-f", "concat",
        "-safe", "0",
        "-i", "tmp_list.txt",
        "-c:v", "libx264",
        "-c:a", "aac",
        str(output_path)
    ])

    for tmp_file in tmp_files:
        os.remove(tmp_file)
    os.remove("tmp_list.txt")

    return True


# =========================
# MAIN
# =========================
if __name__=="__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--clips_dir", required=True)
    parser.add_argument("--job_id", required=True)
    parser.add_argument("--video_id", required=True)
    parser.add_argument("--summary_type", required=False, default="goals")

    args = parser.parse_args()

    start_time = time.time()
    update(args.job_id, "started_at", int(start_time))

    update(args.job_id, "status", "processing")
    update(args.job_id, "stage", "loading_model")
    update(args.job_id, "progress", 5)

    summary_type_lower = (args.summary_type or "goals").lower()

    if "card" in summary_type_lower:
        model_type = "cards"
    else:
        model_type = "goals"

    resnet, clf = load_model(DEVICE, model_type, GOALS_MODEL, CARDS_MODEL)

    clips = [f for f in os.listdir(args.clips_dir) if f.endswith(".mp4")]
    clips = natural_sort(clips)

    all_segments = []

    for i, clip in enumerate(clips):
        update(args.job_id, "stage", f"Processing {clip}")
        progress = int(((i+1)/len(clips))*90)+5
        update(args.job_id,"progress",progress)

        path = os.path.join(args.clips_dir, clip)
        fps = cv2.VideoCapture(path).get(cv2.CAP_PROP_FPS)

        if model_type == "cards":
            segments = run_inference(path, resnet, clf, fps, DEVICE, model_type, threshold=0.6)
        else:
            segments = run_inference(path, resnet, clf, fps, DEVICE, model_type, threshold=0.5)

        for s,e,sc in segments:
            all_segments.append((float(s), float(e), float(sc), clip))

    all_segments.sort(key=lambda x: (x[3], x[0]))

    OUTPUT_DIR = Path(f"C:/Users/LOQ/Desktop/Matchify Laravel/storage/app/public/video_ai/highlights/{args.job_id}")
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    FINAL_HIGHLIGHT = OUTPUT_DIR / "highlight.mp4"

    create_highlight_with_audio(all_segments, args.clips_dir, FINAL_HIGHLIGHT)

    highlights_json = []
    for clip in clips:
        segs = [{"start_time_sec": s, "end_time_sec": e, "confidence_score": sc} 
                for s,e,sc,c in all_segments if c==clip]
        if segs:
            highlights_json.append({
                "clip": clip,
                "segments": segs,
                "highlight_video": f"/storage/video_ai/highlights/{args.job_id}/highlight.mp4"
            })

    json_result = {
        "success": True,
        "status": "completed",
        "job_id": args.job_id,
        "video_id": args.video_id,
        "summary_type": summary_type_lower,
        "clips_dir": args.clips_dir,
        "video_path": f"/storage/video_ai/highlights/{args.job_id}/highlight.mp4",
        "highlights": highlights_json
    }

    end_time = time.time()
    processing_time = int(end_time - start_time)

    update(args.job_id, "processing_time", processing_time)
    update(args.job_id, "finished_at", int(end_time))

    update(args.job_id, "progress",100)
    update(args.job_id, "status","completed")
    update(args.job_id, "stage","completed")

    print(json.dumps(json_result, ensure_ascii=False))

print("MODEL TYPE =", model_type)
