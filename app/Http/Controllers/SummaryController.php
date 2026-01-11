<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use Predis\Client as PredisClient;
use App\Models\VideoSummary;
use App\Models\Video;
use App\Services\FirebaseService;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;


class SummaryController extends Controller
{
    protected PredisClient $redis;
    protected FirebaseService $firebase;
    public function __construct(FirebaseService $firebase)
{
    $this->firebase = $firebase;

    $this->redis = new PredisClient([
        'scheme' => 'tcp',
        'host'   => '127.0.0.1',
        'port'   => 6379,
    ]);
}


public function generate(Request $request)
{
    $request->validate([
        'clips_dir' => 'required|string',
        'video_id'  => 'required|exists:videos,id',
    ]);

    $jobId = (string) $request->video_id;

    // تهيئة Redis
    $this->redis->set("job:$jobId:status", "queued");
    $this->redis->set("job:$jobId:progress", 0);
    $this->redis->del("job:$jobId:result");

    // إرسال Job للـ ML
    $video = Video::findOrFail($request->video_id);

    // نرسل فقط البيانات الأساسية، بدون أي path نهائي
    $this->redis->lpush("highlight_jobs", json_encode([
        'job_id'       => $jobId,
        'clips_dir'    => $request->clips_dir,
        'video_id'     => $video->id,
        'summary_type' => $video->summary_type,
        'highlight_path' => null,
    ]));

    return response()->json([
        'success' => true,
        'job_id'  => $jobId,
    ]);
}


public function result(string $jobId)
{
    $status = $this->redis->get("job:$jobId:status") ?? 'queued';
    $progress = (int) ($this->redis->get("job:$jobId:progress") ?? 0);

    $result = json_decode($this->redis->get("job:$jobId:result"), true);

    // تحقق إذا المعالجة مكتملة والنتيجة موجودة ولها video_id
    if (!empty($result) && isset($result['video_id']) && in_array($status, ['done', 'مكتمل', 'completed'])) {

        $highlightPath = null;

        if (!empty($result['highlights'])) {
            $allScores = [];

            foreach ($result['highlights'] as $highlight) {
                if (!empty($highlight['segments'])) {
                    foreach ($highlight['segments'] as $seg) {
                        $allScores[] = $seg['confidence_score'] ?? 0;
                    }
                }
            }

            $confidence_score = !empty($allScores) ? array_sum($allScores) / count($allScores) : null;

            $highlightPath = "/storage/video_ai/highlights/{$result['video_id']}/highlight.mp4";

            VideoSummary::updateOrCreate(
                ['video_id' => $result['video_id']],
                [
                    'storage_path'     => $highlightPath,
                    'confidence_score' => $confidence_score,
                    'segments'         => json_encode($result['highlights']),
                    'updated_at'       => now(),
                ]
            );
        }

        // تحديث حالة الفيديو
        $video = Video::find($result['video_id']);
        if ($video) {
            $video->update(['processing_status' => 'done']);
            $this->cleanupAfterProcessing($video);

            if (!empty($video->user->fcm_token)) {
                $this->firebase->sendNotificationToDevice(
                    $video->user->fcm_token,
                    "الفيديو جاهز !",
                    "الفيديو الأخير الذي رفعته أصبح جاهزًا للمشاهدة."
                );
            }
        }

        $result['highlight_video'] = $highlightPath;
    }

    return response()->json([
        'success'  => true,
        'status'   => $status,
        'progress' => $progress,
        'result'   => $result,
    ]);
}

    protected function cleanupAfterProcessing(Video $video)
    {
        $uploadPath = storage_path("app/public/video_ai/uploads/job_{$video->id}");
        $clipsPath  = storage_path("app/public/video_ai/clips/job_{$video->id}");

        $paths = [$uploadPath, $clipsPath];
        $expireSeconds = 60 * 60;  

        foreach ($paths as $path) {
            if (!File::exists($path)) {
                Log::info("Path does not exist: $path");
                continue;
            }

            // استخدام Queue لتأخير الحذف 5 دقائق
            dispatch(function () use ($path) {
                try {
                    if (File::exists($path)) {
                        File::deleteDirectory($path);
                        Log::info("Deleted temporary path: $path");
                    }
                } catch (\Exception $e) {
                    Log::error("Failed to delete $path: " . $e->getMessage());
                }
            })->delay(now()->addMinutes(5));
        }
    }

//        public function myHighlights()
// {
//     $user = Auth::user();

//     $summaries = VideoSummary::whereHas('video', function ($q) use ($user) {
//             $q->where('user_id', $user->id);
//         })
//         ->with('video:id,created_at')
//         ->orderBy('created_at', 'desc')
//         ->get()
//         ->map(function ($summary) {
//             return [
//                 'video_id'        => $summary->video_id,
//                 'highlight_path'  => $summary->storage_path,
               
//             ];
//         });

//     return response()->json([
//         'success'    => true,
//         'highlights' => $summaries
//     ]);
// }
public function myHighlights()
{
    $user = Auth::user();

    $summaries = VideoSummary::whereHas('video', function ($q) use ($user) {
            $q->where('user_id', $user->id);
        })
        ->with('video:id,created_at')
        ->orderBy('created_at', 'desc')
        ->get()
        ->map(function ($summary) {
            
            if (!empty($summary->storage_path)) {
                return [
                    'video_id'       => $summary->video_id,
                    'highlight_path' => $summary->storage_path,
                ];
            }
            return null; 
        })
        ->filter() 
        ->values(); 

    return response()->json([
        'success'    => true,
        'highlights' => $summaries
    ]);
}


}