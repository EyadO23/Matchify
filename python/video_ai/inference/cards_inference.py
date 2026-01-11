import torch
import torch.nn as nn
from torchvision.models.video import r3d_18
from .base_inference import load_video_frames, sliding_windows, merge_segments

class ResidualClassifier(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc1 = nn.Linear(512, 256)
        self.bn1 = nn.BatchNorm1d(256)
        self.fc2 = nn.Linear(256, 256)
        self.bn2 = nn.BatchNorm1d(256)
        self.out = nn.Linear(256, 2)
        self.dropout = nn.Dropout(0.5)

    def forward(self, x):
        h = torch.relu(self.bn1(self.fc1(x)))
        h = self.dropout(h)
        h = h + torch.relu(self.bn2(self.fc2(h)))
        return self.out(h)

def load_cards_model(device, model_path):
    resnet = r3d_18(pretrained=True)
    resnet = nn.Sequential(*list(resnet.children())[:-1])
    resnet.eval().to(device)

    clf = ResidualClassifier().to(device)
    clf.load_state_dict(torch.load(model_path, map_location=device))
    clf.eval()

    return resnet, clf

@torch.no_grad()
def run_cards_inference(video_path, resnet, clf, fps, device, threshold=0.7):
    frames = load_video_frames(video_path)
    windows = sliding_windows(frames)
    preds = []

    for idx, tensor in windows:
        x = tensor.unsqueeze(0).to(device)
        feat = resnet(x).flatten(1)
        probs = torch.softmax(clf(feat), dim=1)[0].cpu().numpy()
        preds.append((idx / fps, probs[1]))


    segments = merge_segments(preds, fps, threshold=threshold)
    return segments
