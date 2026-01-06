from torchvision import transforms
from video_ai.config import IMG_SIZE

video_transform = transforms.Compose([
    transforms.Resize((IMG_SIZE, IMG_SIZE)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.45]*3, std=[0.225]*3),
])
