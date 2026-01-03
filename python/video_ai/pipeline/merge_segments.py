def merge_windows(preds, fps, threshold, max_gap):
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