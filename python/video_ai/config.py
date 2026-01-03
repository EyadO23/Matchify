import torch

MODEL_PATH = r"C:\Users\LOQ\Desktop\Matchify Laravel\python\video_ai\weights\goal_classifier_v2.pt"
DEVICE = "cuda" if torch.cuda.is_available() else "cpu"

NUM_FRAMES = 16
STRIDE = 8
IMG_SIZE = 112

THRESHOLD = 0.5
MAX_GAP = 1.0

