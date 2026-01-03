<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redis;
use Illuminate\Support\Str;

class Upload_VideoController extends Controller
{
    public function upload(Request $request)
    {
        $path = $request->file('video')->store('videos');

        $jobId = (string) Str::uuid();

        Redis::lpush('video_jobs', json_encode([
            'job_id' => $jobId,
            'video_path' => storage_path("app/$path")
        ]));

        Redis::set("job:$jobId:status", "queued");

        return response()->json([
            'job_id' => $jobId,
            'status' => 'queued'
        ]);
    }

    public function status($jobId)
    {
        $status = Redis::get("job:$jobId:status");

        if ($status === 'done') {
            $result = json_decode(
                Redis::get("job:$jobId:result"),
                true
            );

            return response()->json([
                'status' => 'done',
                'result' => $result
            ]);
        }

        if ($status === 'failed') {
            return response()->json([
                'status' => 'failed',
                'error' => Redis::get("job:$jobId:error")
            ]);
        }

        return response()->json([
            'status' => $status ?? 'unknown'
        ]);
    }
}
