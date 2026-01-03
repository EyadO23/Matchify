@echo off
REM ضبط random hash لتجنب الخطأ على Windows
set PYTHONHASHSEED=random

REM تشغيل سكربت Python
call "C:\Users\LOQ\Desktop\Matchify Laravel\venv\Scripts\python.exe" -m video_ai.service.run_inference --clips_dir="%1"
