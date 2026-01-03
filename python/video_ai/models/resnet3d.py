import torch.nn as nn
from torchvision.models.video import r3d_18

def load_resnet3d(device):
    model = r3d_18(pretrained=True)
    model = nn.Sequential(*list(model.children())[:-1])
    model.eval()
    # model.eval().to(device)

    return model