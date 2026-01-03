# import sys
# import os
# import argparse
# import json
# import torch
# import cv2
# import redis

# # =========================
# # Fix PYTHON PATH
# # =========================
# sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

# from video_ai.config import *
# from video_ai.models.resnet3d import load_resnet3d
# from video_ai.models.mlp_goal import MLP
# from video_ai.pipeline.predictor import predict_clip
# from video_ai.pipeline.merge_segments import merge_windows
# from video_ai.utils.video_info import get_fps

# # =========================
# # Redis connection
# # =========================
# r = redis.Redis(host="127.0.0.1", port=6379, decode_responses=True)

# def update(job_id, key, value):
#     """تحديث قيمة في Redis"""
#     r.set(f"job:{job_id}:{key}", value)

# # =========================
# # Load models (مرة واحدة)
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
# # Create highlight video
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
#     for start, end, _ in segments:
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
# # MAIN
# # =========================
# if __name__ == "__main__":
#     parser = argparse.ArgumentParser()
#     parser.add_argument("--clips_dir", required=True)
#     parser.add_argument("--job_id", required=True)

#     # النوع والطول
#     parser.add_argument("--summary_type", type=str, default="goals", choices=["goals", "cards"])
#     parser.add_argument("--summary_length", type=str, default="short", choices=["short", "long"])

#     args = parser.parse_args()

#     CLIPS_DIR = args.clips_dir
#     JOB_ID = args.job_id
#     SUMMARY_TYPE = args.summary_type
#     SUMMARY_LENGTH = args.summary_length

#     # =========================
#     # تحديد threshold تلقائي حسب النوع وطول الملخص
#     # =========================
#     if SUMMARY_TYPE == "goals" and SUMMARY_LENGTH == "short":
#         THRESHOLD = 0.5
#     elif SUMMARY_TYPE == "goals" and SUMMARY_LENGTH == "long":
#         THRESHOLD = 0.5
#     elif SUMMARY_TYPE == "cards" and SUMMARY_LENGTH == "short":
#         THRESHOLD = 0.5
#     else:  # cards long
#         THRESHOLD = 0.5 

#     # إعداد مجلد الخرج
#     OUTPUT_DIR = os.path.join(os.path.dirname(CLIPS_DIR), "summaryOut")
#     os.makedirs(OUTPUT_DIR, exist_ok=True)

#     # تحديث حالة job
#     update(JOB_ID, "status", "processing")
#     update(JOB_ID, "stage", "starting inference")
#     update(JOB_ID, "progress", 1)

#     resnet, clf = load_models(JOB_ID)

#     clips = [f for f in os.listdir(CLIPS_DIR) if f.endswith(".mp4")]
#     total = len(clips)

#     results = {}
#     highlights = []

#     for i, clip in enumerate(clips):
#         update(JOB_ID, "stage", f"processing {clip}")

#         progress = int(((i + 1) / total) * 90) + 5
#         update(JOB_ID, "progress", progress)

#         path = os.path.join(CLIPS_DIR, clip)
#         preds, segments = process_clip(path, resnet, clf, THRESHOLD)

#         results[clip] = {
#             "predictions_per_frame": preds,
#             "highlight_segments": segments
#         }

#         if segments:
#             output_path = os.path.join(OUTPUT_DIR, f"highlight_{clip}")
#             if create_highlight_video(path, segments, output_path):
#                 highlights.append({
#                     "clip": clip,
#                     "segments": segments,
#                     "highlight_video": output_path
#                 })

#     # =========================
#     # تحديث النتائج في Redis
#     # =========================
#     update(JOB_ID, "progress", 100)
#     update(JOB_ID, "status", "done")
#     update(JOB_ID, "stage", "finished")

#     update(JOB_ID, "result", json.dumps({
#         "highlights": highlights,
#         "raw_results": results,
#         "summary_type": SUMMARY_TYPE,
#         "summary_length": SUMMARY_LENGTH,
#         "threshold": THRESHOLD
#     }))

#     print("[INFO] All highlights processed and saved.")


import sys
import os
import argparse
import json
import torch
import cv2
import redis

# =========================
# Fix PYTHON PATH
# =========================
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))


from video_ai.config import *
from video_ai.models.resnet3d import load_resnet3d
from video_ai.models.mlp_goal import MLP
from video_ai.pipeline.predictor import predict_clip
from video_ai.pipeline.merge_segments import merge_windows
from video_ai.utils.video_info import get_fps

# =========================
# Redis connection
# =========================
r = redis.Redis(host="127.0.0.1", port=6379, decode_responses=True)

def update(job_id, key, value):
    """تحديث قيمة في Redis"""
    r.set(f"job:{job_id}:{key}", value)

# =========================
# Load models (مرة واحدة)
# =========================
def load_models(job_id):
    update(job_id, "stage", "loading model")
    update(job_id, "progress", 5)

    resnet = load_resnet3d(DEVICE)
    clf = MLP().to(DEVICE)
    clf.load_state_dict(torch.load(MODEL_PATH, map_location=DEVICE))
    clf.eval()

    return resnet, clf

# =========================
# Process one clip
# =========================
def process_clip(video_path, resnet, clf, threshold):
    fps = get_fps(video_path)
    preds = predict_clip(video_path, resnet, clf, DEVICE)
    segments = merge_windows(preds, fps, threshold, MAX_GAP)
    return preds, segments

# =========================
# Create highlight video
# =========================
def create_highlight_video(input_video, segments, output_path, margin=1.0):
    if not segments:
        return False

    cap = cv2.VideoCapture(input_video)
    fps = cap.get(cv2.CAP_PROP_FPS)
    width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

    out = cv2.VideoWriter(
        output_path,
        cv2.VideoWriter_fourcc(*"mp4v"),
        fps,
        (width, height)
    )

    frames_to_keep = set()
    for start, end, _ in segments:
        s = max(int((start - margin) * fps), 0)
        e = int((end + margin) * fps) + 1
        frames_to_keep.update(range(s, e))

    idx = 0
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        if idx in frames_to_keep:
            out.write(frame)
        idx += 1

    cap.release()
    out.release()
    return True

# =========================
# MAIN
# =========================
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--clips_dir", required=True)
    parser.add_argument("--job_id", required=True)

    # النوع والطول
    parser.add_argument("--summary_type", type=str, default="goals", choices=["goals", "cards"])
    parser.add_argument("--summary_length", type=str, default="short", choices=["short", "long"])

    args = parser.parse_args()

    CLIPS_DIR = args.clips_dir
    JOB_ID = args.job_id
    SUMMARY_TYPE = args.summary_type
    SUMMARY_LENGTH = args.summary_length

    # =========================
    # تحديد threshold تلقائي حسب النوع وطول الملخص
    # =========================
    if SUMMARY_TYPE == "goals" and SUMMARY_LENGTH == "short":
        THRESHOLD = 0.5
    elif SUMMARY_TYPE == "goals" and SUMMARY_LENGTH == "long":
        THRESHOLD = 0.5
    elif SUMMARY_TYPE == "cards" and SUMMARY_LENGTH == "short":
        THRESHOLD = 0.5
    else:  # cards long
        THRESHOLD = 0.5 

    # إعداد مجلد الخرج لكل job
    OUTPUT_DIR = os.path.join("C:/Users/LOQ/Desktop/Matchify Laravel/storage/app/video_ai/highlights", JOB_ID)
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    # اسم الفيديو النهائي
    FINAL_HIGHLIGHT = os.path.join(OUTPUT_DIR, "highlight.mp4")

    # تحديث حالة job
    update(JOB_ID, "status", "processing")
    update(JOB_ID, "stage", "starting inference")
    update(JOB_ID, "progress", 1)

    resnet, clf = load_models(JOB_ID)

    clips = [f for f in os.listdir(CLIPS_DIR) if f.endswith(".mp4")]
    total = len(clips)

    results = {}
    highlights = []

    for i, clip in enumerate(clips):
        update(JOB_ID, "stage", f"processing {clip}")

        progress = int(((i + 1) / total) * 90) + 5
        update(JOB_ID, "progress", progress)

        path = os.path.join(CLIPS_DIR, clip)
        preds, segments = process_clip(path, resnet, clf, THRESHOLD)

        results[clip] = {
            "predictions_per_frame": preds,
            "highlight_segments": segments
        }

        if segments:
            # ندمج كل الـ clips في فيديو واحد فقط
            create_highlight_video(path, segments, FINAL_HIGHLIGHT)

            highlights.append({
                "clip": clip,
                "segments": segments,
                "highlight_video": f"video_ai/highlights/{JOB_ID}/highlight.mp4"
            })

    # =========================
    # تحديث النتائج في Redis
    # =========================
    update(JOB_ID, "progress", 100)
    update(JOB_ID, "status", "done")
    update(JOB_ID, "stage", "finished")

    update(JOB_ID, "result", json.dumps({
        "highlights": highlights,
        "raw_results": results,
        "summary_type": SUMMARY_TYPE,
        "summary_length": SUMMARY_LENGTH,
        "threshold": THRESHOLD,
        "video_path": f"video_ai/highlights/{JOB_ID}/highlight.mp4"
    }))

    print(f"[INFO] Highlight video saved at {FINAL_HIGHLIGHT}")
