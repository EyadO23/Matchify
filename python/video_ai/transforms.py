from torchvision import transforms
from video_ai.config import IMG_SIZE

video_transform = transforms.Compose([
    transforms.Resize((IMG_SIZE, IMG_SIZE)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.45]*3, std=[0.225]*3),
])
# import cv2
# import torch
# from transforms import video_transform

# def sliding_windows(video_path, window_size=16, stride=8):
#     cap = cv2.VideoCapture(video_path)
#     frames = []

#     while True:
#         ret, frame = cap.read()
#         if not ret:
#             break

#         frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
#         frame = video_transform(frame)  # 🔥 هون صار يشتغل فعلياً
#         frames.append(frame)

#     cap.release()

#     windows = []
#     for i in range(0, len(frames) - window_size + 1, stride):
#         clip = torch.stack(frames[i:i+window_size])
#         windows.append((i, clip))

#     return windows
