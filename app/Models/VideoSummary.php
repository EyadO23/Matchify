<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VideoSummary extends Model
{
    protected $fillable = [
        'video_id',         
        'job_id',          
        'clips_dir',        

        'storage_path',     
        'confidence_score', 
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
