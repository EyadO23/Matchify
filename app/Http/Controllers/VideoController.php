<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Predis\Client as PredisClient;
use App\Models\Video;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;

class VideoController extends Controller
{
    protected PredisClient $redis;

    public function __construct()
    {
        $this->redis = new PredisClient([
            'scheme' => 'tcp',
            'host'   => '127.0.0.1',
            'port'   => 6379,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'video'          => 'required|file|mimes:mp4,mov,avi|max:1024000',
            'summary_type'   => 'required|in:goals,cards'
        ]);

       
        $video = Video::create([
            'user_id'           => Auth::id(),
            'summary_type'      => $request->summary_type,
            'processing_status' => 'uploaded',
            'duration_seconds'  => null,
        ]);

        $jobId = $video->id;

        // المسارات
        $uploadDir = storage_path("app/public/video_ai/uploads/job_$jobId");
        $clipsDir  = storage_path("app/public/video_ai/clips/job_$jobId");

        if (!file_exists($uploadDir)) mkdir($uploadDir, 0777, true);
        if (!file_exists($clipsDir)) mkdir($clipsDir, 0777, true);

        // حفظ الفيديو مؤقتًا
        $videoName = 'original.mp4';
        $videoFilePath = "$uploadDir/$videoName";
        $request->file('video')->move($uploadDir, $videoName);

        $relativeClipsDir  = "storage/app/public/video_ai/clips/job_$jobId";

        /**
         * ============================
         * حساب مدة الفيديو بالثواني
         * ============================
         */
        $escapedPath = escapeshellarg($videoFilePath);
        $command = "ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $escapedPath";
        $output = shell_exec($command);
        $durationSeconds = is_numeric($output) ? (int) round((float) $output) : null;

        // تحديث حالة المعالجة فقط
        $video->update([
            'duration_seconds'  => $durationSeconds,
            'processing_status' => 'processing',
        ]);
        $video->refresh();

        // إرسال job إلى Redis ليتم معالجته بالبايثون
        $this->redis->rpush('video_jobs', json_encode([
            'job_id'         => $jobId,
            'video_path'     => $videoFilePath,
            'clips_dir'      => $clipsDir,
            'summary_type'   => $request->summary_type,
             'user_id'         => Auth::id(),
            'duration_sec'   => $durationSeconds,
        ]));

        // Response للواجهة
        return response()->json([
            'success' => true,
            'job_id'  => $jobId,
            'video' => [
                'id'                => $video->id,
                'summary_type'      => $video->summary_type,
                'processing_status' => $video->processing_status,
                'duration_seconds'  => $durationSeconds,
            ],
            'clips_dir' => [
                'relative' => $relativeClipsDir,
                'absolute' => $clipsDir,
            ],
            
        ]);
    }

    public function progress($id)
    {
        $progress = $this->redis->get("job:$id:progress") ?? 0;
        $status   = $this->redis->get("job:$id:status") ?? 'processing';

        return response()->json([
            'job_id'   => $id,
            'progress' => (int) $progress,
            'status'   => $status,
        ]);
    }

   public function report($id)
{
    $video = Video::findOrFail($id);

    $status = $this->redis->get("job:$id:status");
    $progress = $this->redis->get("job:$id:progress");
    $resultJson = $this->redis->get("job:$id:result");

    $result = $resultJson ? json_decode($resultJson, true) : null;

    return response()->json([
        'id'                => $video->id,
        'processing_status' => $status ?? $video->processing_status,
        'progress'          => (int) ($progress ?? 0),
        'result'            => $result,
        'created_at'        => $video->created_at,
    ]);
}
public function reportAll()
{
    // تجيب كل الفيديوهات
    $videos = Video::orderBy('created_at', 'desc')->get();

    $response = $videos->map(function ($video) {
        $status     = $this->redis->get("job:{$video->id}:status");
        $progress   = $this->redis->get("job:{$video->id}:progress");
        $resultJson = $this->redis->get("job:{$video->id}:result");
        $result     = $resultJson ? json_decode($resultJson, true) : null;

        // نتأكد انه highlight_video دايمًا موجود
        $result = $result ?? [];
        $result['highlight_video'] = null;
        if (!empty($result['highlights'])) {
            $result['highlight_video'] = "/storage/video_ai/highlights/{$video->id}/highlight.mp4";
        }

        return [
            'video_id'          => $video->id,
            'user_id'           => $video->user_id,
            'user_name'         => $video->user->name ?? null,
            'summary_type'      => $video->summary_type,
            'processing_status' => $status ?? $video->processing_status,
            'progress'          => (int) ($progress ?? 0),
            'result'            => $result,
            'duration_seconds'  => $video->duration_seconds,
            'created_at'        => $video->created_at,
        ];
    });

    return response()->json([
        'success' => true,
        'videos'  => $response,
    ]);
}

}