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



namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use Predis\Client as PredisClient;
use App\Models\Highlight;

class HighlightController extends Controller
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

    public function generate(Request $request)
    {
        $request->validate([
            'clips_dir'       => 'required|string',
            'summary_type'    => 'required|string',
            'summary_length'  => 'required|string',
        ]);

        $jobId = (string) Str::uuid();

        // تهيئة Redis
        $this->redis->set("job:$jobId:status", "queued");
        $this->redis->set("job:$jobId:progress", 0);
        $this->redis->del("job:$jobId:result");

        // إرسال Job
        $this->redis->lpush("highlight_jobs", json_encode([
            'job_id'         => $jobId,
            'clips_dir'      => $request->clips_dir,
            'summary_type'   => $request->summary_type,
            'summary_length' => $request->summary_length,
            'user_id'        => Auth::id(),
        ]));

        return response()->json([
            'success' => true,
            'job_id'  => $jobId,
        ]);
    }

    public function result(string $jobId)
    {
        $status = $this->redis->get("job:$jobId:status");

        if (!$status) {
            return response()->json(['success' => false], 404);
        }

        $result = json_decode(
            $this->redis->get("job:$jobId:result"),
            true
        );

        if ($status === 'completed' && $result) {
            Highlight::updateOrCreate(
                ['job_id' => $jobId],
                [
                    'user_id'        => $result['user_id'] ?? Auth::id(),
                    'clips_dir'      => $result['clips_dir'] ?? null, // ✅ مهم لإصلاح الخطأ
                    'summary_type'   => $result['summary_type'] ?? null,
                    'summary_length' => $result['summary_length'] ?? null,
                    'storage_path'   => $result['video_path'] ?? null,
                    'result'         => json_encode($result),
                    'status'         => 'completed',
                ]
            );
        }

        return response()->json([
            'success'  => true,
            'status'   => $status,
            'progress' => (int) $this->redis->get("job:$jobId:progress"),
            'result'   => $result,
        ]);
    }
}
