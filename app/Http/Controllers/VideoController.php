<?php

// namespace App\Http\Controllers;

// use Illuminate\Http\Request;
// use Illuminate\Support\Facades\Auth;
// use Predis\Client as PredisClient;
// use App\Models\Video;


// class VideoController extends Controller
// {
//     protected PredisClient $redis;

//     public function __construct()
//     {
//         $this->redis = new PredisClient([
//             'scheme' => 'tcp',
//             'host'   => '127.0.0.1',
//             'port'   => 6379,
//         ]);
//     }

// public function store(Request $request)
// {
//     $request->validate([
//         'video'          => 'required|file|mimes:mp4,mov,avi|max:1024000',
//         'summary_type'   => 'required|in:اهداف,بطاقة حمراء,بطاقة صفراء',
//         'summary_length' => 'required|in:قصير,طويل',
//     ]);

//     // إنشاء سجل الفيديو بدون حساب المدة (سوف تُحسب في البايثون)
//     $video = Video::create([
//         'user_id'           => Auth::id(),
//         'summary_type'      => $request->summary_type,
//         'summary_length'    => $request->summary_length,
//         'processing_status' => 'uploaded',
//         'duration_seconds'  => null,
//     ]);

//     $jobId = $video->id;

//     // المسارات
//     $uploadDir = storage_path("app/public/video_ai/uploads/job_$jobId");
//     $clipsDir  = storage_path("app/public/video_ai/clips/job_$jobId");

//     if (!file_exists($uploadDir)) mkdir($uploadDir, 0777, true);
//     if (!file_exists($clipsDir)) mkdir($clipsDir, 0777, true);

//     // حفظ الفيديو مؤقتًا
//     $videoName = 'original.mp4';
//     $videoFilePath = "$uploadDir/$videoName";
//     $request->file('video')->move($uploadDir, $videoName);

//     $relativeClipsDir  = "storage/app/public/video_ai/clips/job_$jobId";
//   /**
//      * ============================
//      * حساب مدة الفيديو بالثواني
//      * ============================
//      */
//     $escapedPath = escapeshellarg($videoFilePath);

// $command = "ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $escapedPath";

// $output = shell_exec($command);

// $durationSeconds = is_numeric($output)
//     ? (int) round((float) $output)
//     : null;

//     // تحديث حالة المعالجة فقط
//     $video->update([
//         'duration_seconds'  => $durationSeconds,
//         'processing_status'=> 'processing',
//     ]);
//     $video->refresh();
    


//     // إرسال job إلى Redis ليتم معالجته بالبايثون
//     $this->redis->rpush('video_jobs', json_encode([
//         'job_id'         => $jobId,
//         'video_path'     => $videoFilePath,
//         'clips_dir'      => $clipsDir,
//         'summary_type'   => $request->summary_type,
//         'summary_length' => $request->summary_length,
//         'user_id'        => Auth::id(),
//         'duration_sec'   => $durationSeconds,
//     ]));

//     // Response للواجهة
//     return response()->json([
//         'success' => true,
//         'job_id'  => $jobId,
//         'video' => [
//             'id'                => $video->id,
//             'summary_type'      => $video->summary_type,
//             'summary_length'    => $video->summary_length,
//             'processing_status' => $video->processing_status,
//             'duration_seconds'  => $durationSeconds, // سيتم حسابه في البايثون
//         ],
//         'clips_dir' => [
//             'relative' => $relativeClipsDir,
//             'absolute' => $clipsDir,
//         ],
//         'progress' => 0,
//     ]);
// }

// public function progress($id)
// {
//     $progress = $this->redis->get("job:$id:progress") ?? 0;
//     $status   = $this->redis->get("job:$id:status") ?? 'processing';

//     return response()->json([
//         'job_id'   => $id,
//         'progress' => (int) $progress,
//         'status'   => $status,
//     ]);
// }

// public function report($id)
// {
//     $video = Video::with('summary')->findOrFail($id);

//     return response()->json([
//         'id'                => $video->id,
//         'user_id'           => $video->user_id,
//         'summary_type'      => $video->summary_type,
//         'summary_length'    => $video->summary_length,
//         'processing_status' => $video->processing_status,

//         'created_at'        => $video->created_at,
//     ]);
// }
// }


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
            'summary_type'   => 'required|in:اهداف,بطاقة حمراء,بطاقة صفراء',
            'summary_length' => 'required|in:قصير,طويل',
        ]);

        // إنشاء سجل الفيديو بدون حساب المدة (سوف تُحسب في البايثون)
        $video = Video::create([
            'user_id'           => Auth::id(),
            'summary_type'      => $request->summary_type,
            'summary_length'    => $request->summary_length,
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
            'summary_length' => $request->summary_length,
            'user_id'        => Auth::id(),
            'duration_sec'   => $durationSeconds,
        ]));

        // Response للواجهة
        return response()->json([
            'success' => true,
            'job_id'  => $jobId,
            'video' => [
                'id'                => $video->id,
                'summary_type'      => $video->summary_type,
                'summary_length'    => $video->summary_length,
                'processing_status' => $video->processing_status,
                'duration_seconds'  => $durationSeconds,
            ],
            'clips_dir' => [
                'relative' => $relativeClipsDir,
                'absolute' => $clipsDir,
            ],
            'progress' => 0,
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
        $video = Video::with('summary')->findOrFail($id);

        return response()->json([
            'id'                => $video->id,
            'user_id'           => $video->user_id,
            'summary_type'      => $video->summary_type,
            'summary_length'    => $video->summary_length,
            'processing_status' => $video->processing_status,
            'created_at'        => $video->created_at,
        ]);
    }
/**
 * ============================
 * تنظيف الفيديوهات القديمة مع Debug كامل (Windows / تجربة 5 دقائق)
 * ============================
 */
public function cleanOldVideos()
{
    $uploadBase = storage_path('app/public/video_ai/uploads');
    $clipsBase  = storage_path('app/public/video_ai/clips');

    $now = time();
    $expireSeconds = 5 * 60; // 5 دقائق للتجربة

    foreach ([$uploadBase, $clipsBase] as $basePath) {

        if (!File::exists($basePath)) {
            Log::info("Base path does not exist: $basePath");
            continue;
        }

        foreach (File::directories($basePath) as $jobDir) {

            $jobId = str_replace('job_', '', basename($jobDir));
            $video = Video::find($jobId);

            // لحماية highlights النهائية: إذا الفيديو موجود ومعالج، تجاهل
            if ($video && $video->processing_status === 'done') {
                Log::info("Skipping JobDir (done): $jobDir");
                continue;
            }

            $lastModified = File::lastModified($jobDir);
            $diff = $now - $lastModified;

            Log::info("Checking JobDir: $jobDir, lastModified: "
                . date('Y-m-d H:i:s', $lastModified)
                . ", now: " . date('Y-m-d H:i:s', $now)
                . ", diffSeconds: $diff");

            // إذا مضى أكثر من $expireSeconds احذف المجلد
            if ($diff > $expireSeconds) {
                try {
                    File::deleteDirectory($jobDir);
                    Log::info("Deleted JobDir: $jobDir");
                } catch (\Exception $e) {
                    Log::error("Failed to delete $jobDir: " . $e->getMessage());
                }
            } else {
                Log::info("JobDir not expired yet: $jobDir");
            }
        }
    }

    return response()->json([
        'success' => true,
        'message' => "تم تنظيف الفيديوهات القديمة بعد {$expireSeconds} ثانية (5 دقائق) بنجاح",
    ]);
}
}