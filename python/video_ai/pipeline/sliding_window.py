import cv2
import torch
from PIL import Image
from video_ai.transforms import video_transform
from video_ai.config import NUM_FRAMES, STRIDE

def sliding_windows(video_path):
    cap = cv2.VideoCapture(video_path)
    frames = []

    while True:
        ret, frame = cap.read()
        if not ret:
            break
        frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        frames.append(video_transform(Image.fromarray(frame)))

    cap.release()

    windows = []
    for i in range(0, len(frames) - NUM_FRAMES + 1, STRIDE):
        clip = torch.stack(frames[i:i+NUM_FRAMES], dim=1)
        windows.append((i, clip))

    return windows