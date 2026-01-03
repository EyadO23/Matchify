import torch
from video_ai.pipeline.sliding_window import sliding_windows

@torch.no_grad()
def predict_clip(video_path, resnet3d, clf, device):
    windows = sliding_windows(video_path)
    preds = []

    for idx, tensor in windows:
        x = tensor.unsqueeze(0).to(device)
        feat = resnet3d(x).flatten(1)
        prob = torch.softmax(clf(feat), dim=1)[0,1].item()

        preds.append({
            "frame_idx": idx,
            "prob": prob
        })

    return preds