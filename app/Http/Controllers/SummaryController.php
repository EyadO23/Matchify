<?php

// namespace App\Http\Controllers;

// use Illuminate\Http\Request;
// use Illuminate\Support\Facades\Auth;
// use Illuminate\Support\Str;
// use Predis\Client as PredisClient;
// use App\Models\Highlight;

// class HighlightController extends Controller
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

//     public function generate(Request $request)
//     {
//         $request->validate([
//             'clips_dir'       => 'required|string',
//             'summary_type'    => 'required|string',
//             'summary_length'  => 'required|string',
//         ]);

//         $jobId = (string) Str::uuid();

//         // تهيئة Redis
//         $this->redis->set("job:$jobId:status", "queued");
//         $this->redis->set("job:$jobId:progress", 0);
//         $this->redis->del("job:$jobId:result");

//         // إرسال Job
//         $this->redis->lpush("highlight_jobs", json_encode([
//             'job_id'         => $jobId,
//             'clips_dir'      => $request->clips_dir,
//             'summary_type'   => $request->summary_type,
//             'summary_length' => $request->summary_length,
//             'user_id'        => Auth::id(),
//         ]));

//         return response()->json([
//             'success' => true,
//             'job_id'  => $jobId,
//         ]);
//     }

//     public function result(string $jobId)
// {
//     $status = $this->redis->get("job:$jobId:status");

//     if (!$status) {
//         return response()->json(['success' => false], 404);
//     }

//     $result = json_decode(
//         $this->redis->get("job:$jobId:result"),
//         true
//     );

//     if ($status === 'completed' && $result) {
//         Highlight::updateOrCreate(
//             ['job_id' => $jobId],
//             [
//                 'user_id'        => $result['user_id'] ?? Auth::id(),
//                 'summary_type'   => $result['summary_type'] ?? null,
//                 'summary_length' => $result['summary_length'] ?? null,
//                 'storage_path'   => $result['video_path'] ?? null,
//                 'result'         => json_encode($result),
//                 'status'         => 'completed',
//             ]
//         );
//     }

//     return response()->json([
//         'success'  => true,
//         'status'   => $status,
//         'progress' => (int) $this->redis->get("job:$jobId:progress"),
//         'result'   => $result,
//     ]);
// }

// }




// class SummaryController extends Controller
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

//     public function generate(Request $request)
// {
//     $request->validate([
//         'clips_dir'       => 'required|string',
//         'video_id'        => 'required|exists:videos,id',
//         'summary_type'    => 'required|string',  // اختياري للاستخدام بالـ ML
//         'summary_length'  => 'required|string',  // اختياري للاستخدام بالـ ML
//     ]);

//     $jobId = (string) Str::uuid();

//     // تهيئة Redis
//     $this->redis->set("job:$jobId:status", "queued");
//     $this->redis->set("job:$jobId:progress", 0);
//     $this->redis->del("job:$jobId:result");

//     // إرسال Job للـ ML
//     $this->redis->lpush("highlight_jobs", json_encode([
//         'job_id'         => $jobId,
//         'clips_dir'      => $request->clips_dir,
//         'video_id'       => $request->video_id,
//         'summary_type'   => $request->summary_type,
//         'summary_length' => $request->summary_length,
//     ]));

//     return response()->json([
//         'success' => true,
//         'job_id'  => $jobId,
//     ]);
// }

//     public function result(string $jobId)
// {
//     // قراءة حالة المعالجة من Redis
//     $status = $this->redis->get("job:$jobId:status") ?? 'queued';
//     $progress = (int) $this->redis->get("job:$jobId:progress") ?? 0;

//     // إذا المعالجة مكتملة والنتيجة موجودة
//     $result = json_decode($this->redis->get("job:$jobId:result"), true);

//     if ($status === 'completed' && $result) {
//         // تحديث أو إنشاء Summary مرتبط بالفيديو
//         VideoSummary::updateOrCreate(
//             ['video_id' => $result['video_id']],  
//             [  'storage_path'      => $result['clips_dir'] ?? null,
//                 'start_time_sec'    => $result['start_time_sec'] ?? 0,
//                 'end_time_sec'      => $result['end_time_sec'] ?? 0,
//                 'confidence_score'  => $result['confidence_score'] ?? null,
//                 'updated_at'        => now(),
//             ]
//         );

//         // تحديث حالة الفيديو نفسه
//         $video = Video::find($result['video_id']);
//         if ($video) {
//             $video->update([
//                 'processing_status' => 'done',
//             ]);
//         }
//     }

//     // Response للواجهة مع progress
//     return response()->json([
//         'success'  => true,
//         'status'   => $status,
//         'progress' => $progress, 
//         'result'   => $result,
//     ]);
// }
// }

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use Predis\Client as PredisClient;
use App\Models\VideoSummary;
use App\Models\Video;
use App\Services\FirebaseService;


class SummaryController extends Controller
{
    protected PredisClient $redis;
    protected FirebaseService $firebase;
    public function __construct()
    {
        $this->redis = new PredisClient([
            'scheme' => 'tcp',
            'host'   => '127.0.0.1',
            'port'   => 6379,
        ]);
    }

    public function generate(Request $request)
    {
        $request->validate([
            'clips_dir'       => 'required|string',
            'video_id'        => 'required|exists:videos,id',
            'summary_type'    => 'required|string',
            'summary_length'  => 'required|string',
        ]);

        $jobId = (string) Str::uuid();

        // تهيئة Redis
        $this->redis->set("job:$jobId:status", "queued");
        $this->redis->set("job:$jobId:progress", 0);
        $this->redis->del("job:$jobId:result");

        // إرسال Job للـ ML
        $this->redis->lpush("highlight_jobs", json_encode([
            'job_id'         => $jobId,
            'clips_dir'      => $request->clips_dir,
            'video_id'       => $request->video_id,
            'summary_type'   => $request->summary_type,
            'summary_length' => $request->summary_length,
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

    if (!empty($result) && in_array($status, ['done', 'مكتمل', 'completed'])) {

        if (!empty($result['highlights'])) {
            $allStartTimes = [];
            $allEndTimes   = [];
            $allScores     = [];

            foreach ($result['highlights'] as $highlight) {
                if (!empty($highlight['segments'])) {
                    foreach ($highlight['segments'] as $seg) {
                        $allStartTimes[] = $seg['start_time_sec'] ?? 0;
                        $allEndTimes[]   = $seg['end_time_sec'] ?? 0;
                        $allScores[]     = $seg['confidence_score'] ?? 0;
                    }
                }
            }

            $start_time_sec   = !empty($allStartTimes) ? min($allStartTimes) : 0;
            $end_time_sec     = !empty($allEndTimes) ? max($allEndTimes) : 0;
            $confidence_score = !empty($allScores) ? array_sum($allScores) / count($allScores) : null;

            VideoSummary::updateOrCreate(
                ['video_id' => $result['video_id']],
                [
                    'storage_path'     => $result['clips_dir'] ?? null,
                    'start_time_sec'   => $start_time_sec,
                    'end_time_sec'     => $end_time_sec,
                    'confidence_score' => $confidence_score,
                    'segments'         => json_encode($result['highlights']),
                    'updated_at'       => now(),
                ]
            );

            $video = Video::find($result['video_id']);
            if ($video) {
                $video->update(['processing_status' => 'done']);


                 // =============================
                    // إرسال إشعار للمستخدم
                    // =============================
                    if (!empty($video->user->fcm_token)) {
                        $this->firebase->sendNotificationToDevice(
                            $video->user->fcm_token,
                            "فيديوك جاهز!",
                            "الفيديو الأخير الذي رفعته أصبح جاهزًا للمشاهدة."
                        );}
            }
        }
    }

    return response()->json([
        'success'  => true,
        'status'   => $status,
        'progress' => $progress,
        'result'   => $result,
    ]);
}
}