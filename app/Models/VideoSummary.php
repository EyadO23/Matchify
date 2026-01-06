<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VideoSummary extends Model
{
    protected $fillable = [
        'video_id',         // معرف الفيديو الأصلي
        'job_id',           // معرف الـ job
        'clips_dir',        // مسار الكليبات
        'summary_type',     // نوع الملخص
        'summary_length',   // طول الملخص
        'storage_path',     // مسار الفيديو النهائي
        'start_time_sec',   // وقت بداية الملخص
        'end_time_sec',     // وقت نهاية الملخص
        'confidence_score', // درجة الثقة بالملخص
    ];

    protected $casts = [
        'result' => 'array',
    ];

    /**
     * علاقة Summary بالمستخدم
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * علاقة Summary بالفيديو الأصلي
     */
    public function video()
    {
        return $this->belongsTo(Video::class);
    }
}
