import cv2
from PIL import Image
import torch
import torchvision.transforms as T

IMG_SIZE = 112
NUM_FRAMES = 16
STRIDE = 8

transform = T.Compose([
    T.Resize((IMG_SIZE, IMG_SIZE)),
    T.ToTensor(),
    T.Normalize(mean=[0.45, 0.45, 0.45], std=[0.225, 0.225, 0.225])
])

def load_video_frames(video_path):
    cap = cv2.VideoCapture(video_path)
    frames = []
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        frames.append(Image.fromarray(frame))
    cap.release()
    return frames

def sliding_windows(frames):
    windows = []
    for i in range(0, len(frames) - NUM_FRAMES + 1, STRIDE):
        clip = frames[i:i + NUM_FRAMES]
        imgs = [transform(img) for img in clip]
        video = torch.stack(imgs, dim=1)
        windows.append((i, video))
    return windows

def merge_segments(preds, fps, threshold=0.5):
    segments = []
    current = None

    for t, prob in preds:
        if prob >= threshold:
            if current is None:
                current = [t, t, prob]
            else:
                current[1] = t
                current[2] = max(current[2], prob)
        else:
            if current:
                segments.append(tuple(current))
                current = None

    if current:
        segments.append(tuple(current))

    return segments
