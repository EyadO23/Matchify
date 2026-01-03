<?php

// namespace App\Http\Controllers;

// use Illuminate\Http\Request;
// use Illuminate\Support\Facades\Auth;
// use Illuminate\Support\Str;
// use Predis\Client as PredisClient;
// use App\Models\Filtter;

// class FiltterController extends Controller
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

//     public function store(Request $request)
//     {
//         // 1️⃣ Validation
//         $request->validate([
//             'video'        => 'required|file|mimes:mp4,mov,avi',
//             'filter_type'  => 'required|string',
//             'summary_type' => 'required|string',
//         ]);

//         // 2️⃣ إنشاء سجل بالـ DB (بدون url مبدئيًا)
//         $filter = Filtter::create([
//             'user_id'      => Auth::id(),
//             'filter_type'  => $request->filter_type,
//             'summary_type' => $request->summary_type,
//             'status'       => 'queued',
//         ]);

//         $jobId = $filter->id;

//         // 3️⃣ تجهيز المسارات
//         $uploadDir = storage_path("app/video_ai/uploads/job_$jobId");
//         $clipsDir  = storage_path("app/video_ai/clips/job_$jobId");

//         if (!file_exists($uploadDir)) {
//             mkdir($uploadDir, 0777, true);
//         }

//         if (!file_exists($clipsDir)) {
//             mkdir($clipsDir, 0777, true);
//         }

//         // 4️⃣ حفظ الفيديو
//         $videoName = 'original.mp4';
//         $request->file('video')->move($uploadDir, $videoName);

//         // 5️⃣ تحديث url في DB (المسار النسبي)
//         $relativePath = "video_ai/uploads/job_$jobId/$videoName";

//         $filter->update([
//             'url' => $relativePath,
//         ]);

//         // 6️⃣ إرسال Job للـ Worker
//         $this->redis->rpush('video_filter_jobs', json_encode([
//             'job_id'           => $jobId,
//             'video_path'       => "$uploadDir/$videoName",
//             'output_clips_dir' => $clipsDir,
//             'filter_type'      => $request->filter_type,
//             'summary_type'     => $request->summary_type,
//         ]));

//         return response()->json([
//             'success' => true,
//             'job_id'  => $jobId,
//             'status'  => 'queued',
//         ]);
//     }
// }



namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Predis\Client as PredisClient;
use App\Models\Filtter;

class FiltterController extends Controller
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
        // 1️⃣ Validation
        $request->validate([
            'video'        => 'required|file|mimes:mp4,mov,avi',
            'filter_type'  => 'required|string',
            'summary_type' => 'required|string',
        ]);

        // 2️⃣ إنشاء سجل بالـ DB (بدون url مبدئيًا)
        $filter = Filtter::create([
            'user_id'      => Auth::id(),
            'filter_type'  => $request->filter_type,
            'summary_type' => $request->summary_type,
            'status'       => 'queued',
        ]);

        $jobId = $filter->id;

        // 3️⃣ تجهيز المسارات مع prefix job_
        $uploadDir = storage_path("app/video_ai/uploads/job_$jobId");
        $clipsDir  = storage_path("app/video_ai/clips/job_$jobId");

        if (!file_exists($uploadDir)) {
            mkdir($uploadDir, 0777, true);
        }

        if (!file_exists($clipsDir)) {
            mkdir($clipsDir, 0777, true);
        }

        // 4️⃣ حفظ الفيديو
        $videoName = 'original.mp4';
        $request->file('video')->move($uploadDir, $videoName);

        // 5️⃣ تحديث url في DB (المسار النسبي)
        $relativePath = "video_ai/uploads/job_$jobId/$videoName";
        $filter->update([
            'url' => $relativePath,
        ]);

        // 6️⃣ إرسال Job للـ Worker
        $this->redis->rpush('video_filter_jobs', json_encode([
            'job_id'           => $jobId,
            'video_path'       => "$uploadDir/$videoName",
            'output_clips_dir' => $clipsDir,
            'filter_type'      => $request->filter_type,
            'summary_type'     => $request->summary_type,
        ]));

        return response()->json([
            'success' => true,
            'job_id'  => $jobId,
            'status'  => 'queued',
        ]);
    }
}
