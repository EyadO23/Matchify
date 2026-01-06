# import sys
# import os
# import argparse
# import json
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
# from video_ai.utils.video_info import get_fps

# # =========================
# # Redis connection
# # =========================
# r = redis.Redis(host="127.0.0.1", port=6379, decode_responses=True)

# def update(job_id, key, value):
#     r.set(f"job:{job_id}:{key}", value)

# # =========================
# # Load models (مرة واحدة)
# # =========================
# def load_models(job_id):
#     update(job_id, "stage", "تحميل النموذج")
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
#     parser.add_argument("--video_id", required=True)  
#     parser.add_argument("--user_id", required=True)   

#     parser.add_argument("--summary_type", type=str, default="اهداف", choices=["اهداف", "كرت احمر","كرت اصفر"])
#     parser.add_argument("--summary_length", type=str, default="قصير", choices=["قصير", "طويل"])

#     args = parser.parse_args()

#     CLIPS_DIR = args.clips_dir
#     JOB_ID = args.job_id
#     VIDEO_ID = args.video_id
#     USER_ID = args.user_id
#     SUMMARY_TYPE = args.summary_type
#     SUMMARY_LENGTH = args.summary_length

#     THRESHOLD = 0.5  # يمكن تعديل حسب النوع والطول

#     OUTPUT_DIR = os.path.join("C:/Users/LOQ/Desktop/Matchify Laravel/storage/app/video_ai/highlights", JOB_ID)
#     os.makedirs(OUTPUT_DIR, exist_ok=True)
#     FINAL_HIGHLIGHT = os.path.join(OUTPUT_DIR, "highlight.mp4")

#     update(JOB_ID, "status", "جارٍ المعالجة")
#     update(JOB_ID, "stage", "بدء التحليل")
#     update(JOB_ID, "progress", 1)

#     resnet, clf = load_models(JOB_ID)

#     clips = [f for f in os.listdir(CLIPS_DIR) if f.endswith(".mp4")]
#     total = len(clips)

#     highlights = []

#     for i, clip in enumerate(clips):
#         update(JOB_ID, "stage", f"معالجة {clip}")
#         progress = int(((i + 1) / total) * 90) + 5
#         update(JOB_ID, "progress", progress)

#         path = os.path.join(CLIPS_DIR, clip)
#         preds, segments = process_clip(path, resnet, clf, THRESHOLD)

#         if segments:
#             create_highlight_video(path, segments, FINAL_HIGHLIGHT)
#             highlights.append({
#                 "clip": clip,
#                 "segments": segments,
#                 "highlight_video": f"video_ai/highlights/{JOB_ID}/highlight.mp4"
#             })

#     # =========================
#     # تحديث النتائج في Redis لتكون متوافقة مع SummaryController
#     # =========================
#     update(JOB_ID, "progress", 100)
#     update(JOB_ID, "status", "مكتمل")
#     update(JOB_ID, "stage", "مكتمل")

#     update(JOB_ID, "result", json.dumps({
#         "job_id": JOB_ID,
#         "video_id": VIDEO_ID,
#         "user_id": USER_ID,
#         "clips_dir": CLIPS_DIR,
#         "summary_type": SUMMARY_TYPE,
#         "summary_length": SUMMARY_LENGTH,
#         "video_path": f"video_ai/highlights/{JOB_ID}/highlight.mp4",
#         "highlights": highlights
#     }))

#     print(f"[INFO] Highlight video for job {JOB_ID} saved at {FINAL_HIGHLIGHT}")


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
    r.set(f"job:{job_id}:{key}", value)

# =========================
# Load models
# =========================
def load_models(job_id):
    update(job_id, "stage", "تحميل النموذج")
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
    parser.add_argument("--video_id", required=True)
    parser.add_argument("--user_id", required=False)
    parser.add_argument("--summary_type", type=str, default="اهداف", choices=["اهداف", "كرت احمر","كرت اصفر"])
    parser.add_argument("--summary_length", type=str, default="قصير", choices=["قصير", "طويل"])
    args = parser.parse_args()

    CLIPS_DIR = args.clips_dir
    JOB_ID = args.job_id
    VIDEO_ID = args.video_id
    SUMMARY_TYPE = args.summary_type
    SUMMARY_LENGTH = args.summary_length

    THRESHOLD = 0.5

    OUTPUT_DIR = os.path.join("C:/Users/LOQ/Desktop/Matchify Laravel/storage/app/public/video_ai/highlights", JOB_ID)
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    FINAL_HIGHLIGHT = os.path.join(OUTPUT_DIR, "highlight.mp4")

    update(JOB_ID, "status", "جارٍ المعالجة")
    update(JOB_ID, "stage", "بدء التحليل")
    update(JOB_ID, "progress", 1)

    # =========================
    # Load ML models
    # =========================
    resnet, clf = load_models(JOB_ID)

    clips = [f for f in os.listdir(CLIPS_DIR) if f.endswith(".mp4")]
    total = len(clips)
    highlights = []

    for i, clip in enumerate(clips):
        update(JOB_ID, "stage", f"معالجة {clip}")
        progress = int(((i + 1) / total) * 90) + 5
        update(JOB_ID, "progress", progress)

        path = os.path.join(CLIPS_DIR, clip)
        preds, segments = process_clip(path, resnet, clf, THRESHOLD)

        segment_data = []
        for start, end, score in segments:
            segment_data.append({
                "start_time_sec": start,
                "end_time_sec": end,
                "confidence_score": score
            })

        if segments:
            create_highlight_video(path, segments, FINAL_HIGHLIGHT)
            highlights.append({
                "clip": clip,
                "segments": segment_data,
                "highlight_video": f"/storage/video_ai/highlights/{JOB_ID}/highlight.mp4"
            })

        # أي log هنا للـ debug يروح لـ stderr
        print(f"Processed {clip}, segments found: {len(segments)}", file=sys.stderr)

    # =========================
    # Update Redis result
    # =========================
    update(JOB_ID, "progress", 100)
    update(JOB_ID, "status", "مكتمل")
    update(JOB_ID, "stage", "مكتمل")

    # JSON النهائي فقط على stdout مع مسارات HTTP جاهزة للواجهة
    json_result = {
        "job_id": JOB_ID,
        "video_id": VIDEO_ID,
        "clips_dir": CLIPS_DIR,
        "summary_type": SUMMARY_TYPE,
        "summary_length": SUMMARY_LENGTH,
        "video_path": f"/storage/video_ai/highlights/{JOB_ID}/highlight.mp4",
        "highlights": highlights
    }

    # اطبع JSON فقط
    print(json.dumps(json_result))
