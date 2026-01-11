from .goals_inference import load_goals_model, run_goals_inference
from .cards_inference import load_cards_model, run_cards_inference

def load_model(device, model_type, goals_model_path, cards_model_path):
    """
    model_type: 'goals' | 'cards'
    """
    if model_type == "cards":
        return load_cards_model(device, cards_model_path)
    else:
        return load_goals_model(device, goals_model_path)

def run_inference(video_path, resnet, clf, fps, device, model_type, threshold=None):
    """
    threshold: فلترة segments حسب score
    """
    if model_type == "cards":
        return run_cards_inference(
            video_path,
            resnet,
            clf,
            fps,
            device,
            threshold=0.7 if threshold is None else threshold
        )
    else:
        return run_goals_inference(
            video_path,
            resnet,
            clf,
            fps,
            device,
            threshold=0.5 if threshold is None else threshold
        )
