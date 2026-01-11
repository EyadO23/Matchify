import librosa
import numpy as np
import os
from moviepy.editor import VideoFileClip
import time
from pathlib import Path

def extract_audio_segments(
    video_path,
    sr=22050,
    frame_length=2048,
    hop_length=512,
    percentile=90,
    clip_duration=2.5,
    merge_gap=2.0
):
    audio, sr = librosa.load(video_path, sr=sr)

    rms = librosa.feature.rms(
        y=audio,
        frame_length=frame_length,
        hop_length=hop_length
    )[0]

    times = librosa.frames_to_time(
        np.arange(len(rms)),
        sr=sr,
        hop_length=hop_length
    )

    threshold = np.percentile(rms, percentile)
    spike_times = times[rms >= threshold]

    segments = []
    for t in spike_times:
        start = max(0, t - clip_duration / 2)
        end = t + clip_duration / 2
        segments.append((start, end))

    merged = []
    for seg in segments:
        if not merged or seg[0] > merged[-1][1] + merge_gap:
            merged.append(list(seg))
        else:
            merged[-1][1] = max(merged[-1][1], seg[1])

    return [tuple(s) for s in merged], {
        "threshold": float(threshold),
        "num_segments": len(merged)
    }


def cut_video_segments(video_path, segments, output_dir, padding=1.5):
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    video = VideoFileClip(video_path)
    video_duration = video.duration

    clips = []
    total_selected = 0.0

    for i, (start, end) in enumerate(segments):
        s = max(0, start - padding)
        e = min(video_duration, end + padding)

        if e <= s:
            continue

        out_path = output_dir / f"clip_{i}.mp4"

        subclip = video.subclip(s, e)
        if subclip.audio is None:
            print(f"Warning: clip {i} has no audio, copying original audio")
        subclip.write_videofile(
            str(out_path),
            codec="libx264",
            audio_codec="aac",   # ترميز الصوت
            temp_audiofile=str(out_path) + "_temp_audio.m4a",  # مهم لتجنب مشاكل الصوت
            remove_temp=True,
            verbose=False,
            logger=None
        )

        clips.append(str(out_path))
        total_selected += (e - s)

    video.close()

    return clips, {
        "num_clips": len(clips),
        "selected_duration_sec": round(total_selected, 2)
    }


def process_video_highlights(video_path, output_dir, summary_type=None, summary_length=None):
   
    start_time = time.time()

    # استخراج مقاطع الصوت
    segments, audio_stats = extract_audio_segments(video_path)
    
    # قص الفيديو حسب المقاطع
    clips, video_stats = cut_video_segments(video_path, segments, output_dir)

    video = VideoFileClip(video_path)
    total_duration = video.duration
    video.close()

    result = {
        "video_path": video_path,
        "total_duration_sec": round(total_duration, 2),
        "segments": segments,
        "audio_stats": audio_stats,
        "video_stats": video_stats,
        "time_reduction_factor": round(
            total_duration / max(video_stats["selected_duration_sec"], 1), 2
        ),
        "processing_time_sec": round(time.time() - start_time, 2),
        "clips": clips,
        
    }

    return result
