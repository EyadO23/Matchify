# import cv2

# def get_fps(video_path):
#     cap = cv2.VideoCapture(video_path)
#     fps = cap.get(cv2.CAP_PROP_FPS)
#     cap.release()
#     return fps

import cv2

def get_fps(video_path):
    """
    ارجع عدد الإطارات في الثانية (FPS) للفيديو
    """
    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        return 0
    fps = cap.get(cv2.CAP_PROP_FPS)
    cap.release()
    return fps

def get_video_duration(video_path):
    """
    ارجع مدة الفيديو بالثواني
    """
    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        return 0
    fps = cap.get(cv2.CAP_PROP_FPS)
    frame_count = cap.get(cv2.CAP_PROP_FRAME_COUNT)
    duration = frame_count / fps if fps > 0 else 0
    cap.release()
    return duration
