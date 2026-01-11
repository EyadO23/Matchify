import json
import redis
import subprocess
from pathlib import Path
import sys
import re

r = redis.Redis(host="127.0.0.1", port=6379, decode_responses=True)

PYTHON_EXE = r"C:\Users\LOQ\Desktop\Matchify Laravel\venv\Scripts\python.exe"
INFERENCE_SCRIPT = r"C:\Users\LOQ\Desktop\Matchify Laravel\python\video_ai\service\run_inference.py"
HIGHLIGHT_OUTPUT_BASE = Path(r"C:\Users\LOQ\Desktop\Matchify Laravel\storage\app/public/video_ai/highlights")
BASE_URL = "http://localhost"

print("Highlight Worker started...", file=sys.stderr)

while True:
    job = r.brpop("highlight_jobs", timeout=1)
    if not job:
        continue

    _, payload = job
    data = json.loads(payload)

    job_id        = data["job_id"]
    clips_dir     = data["clips_dir"]
    video_id      = data["video_id"]
    summary_type  = data.get("summary_type", "goals")


    try:
        r.set(f"job:{job_id}:status", "processing")
        r.set(f"job:{job_id}:stage", "loading_model")
        r.set(f"job:{job_id}:progress", 5)

        highlight_dir = HIGHLIGHT_OUTPUT_BASE / str(job_id)
        highlight_dir.mkdir(parents=True, exist_ok=True)

        process = subprocess.Popen(
            [
                PYTHON_EXE,
                INFERENCE_SCRIPT,
                f"--clips_dir={clips_dir}",
                f"--job_id={job_id}",
                f"--video_id={video_id}",
                f"--summary_type={summary_type}",
            ],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )

        stdout, stderr = process.communicate()

        if process.returncode != 0:
            raise RuntimeError(stderr)

        match = re.search(r'\{.*\}', stdout, re.DOTALL)
        if not match:
            raise ValueError("No JSON output from inference")

        result = json.loads(match.group(0))
        r.set(f"job:{job_id}:result", json.dumps(result))
        r.set(f"job:{job_id}:progress", 100)
        r.set(f"job:{job_id}:stage", "completed")
        r.set(f"job:{job_id}:status", "completed")

        print(f"Highlight job {job_id} completed", file=sys.stderr)

    except Exception as e:
        r.set(f"job:{job_id}:status", "failed")
        r.set(f"job:{job_id}:stage", "error")
        r.set(f"job:{job_id}:progress", 0)
        r.set(f"job:{job_id}:error", str(e))
        print(f"Highlight job {job_id} failed: {e}", file=sys.stderr)
