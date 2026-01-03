import cv2

def merge_windows(preds, fps, threshold=0.5, max_gap=1.0):
    """
    دمج الـ segments القريبة زمنياً حسب threshold و max_gap
    """
    segments = []
    current = None

    for p in preds:
        t = p["frame_idx"] / fps

        if p["prob"] >= threshold:
            if current is None:
                current = [t, t, p["prob"]]
            elif t - current[1] <= max_gap:
                current[1] = t
                current[2] = max(current[2], p["prob"])
            else:
                segments.append(tuple(current))
                current = [t, t, p["prob"]]
        else:
            if current:
                segments.append(tuple(current))
                current = None

    if current:
        segments.append(tuple(current))

    return segments


def create_highlight_video(input_video, segments, output_path, margin=1.0):
    """
    إنشاء فيديو واحد من مجموعة segments، مع إمكانية إضافة margin ثواني قبل وبعد الحدث
    """
    cap = cv2.VideoCapture(input_video)
    fps = cap.get(cv2.CAP_PROP_FPS)
    width  = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
    out = cv2.VideoWriter(output_path, fourcc, fps, (width, height))

    frames_to_keep = set()
    for start, end, _ in segments:
        start_frame = max(int((start - margin) * fps), 0)
        end_frame = int((end + margin) * fps) + 1
        frames_to_keep.update(range(start_frame, end_frame))

    idx = 0
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        if idx in frames_to_keep:
            out.write(frame)
        idx += 1

    cap.release()
    out.release()
    print(f"[INFO] Highlight video saved to {output_path}")
