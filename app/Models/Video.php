<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Video extends Model
{
    protected $fillable = [
        'user_id',
        'summary_type',
        'summary_length',
        'duration_seconds',
        'processing_status',
    ];

    /**
     * العلاقة مع المستخدم
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * العلاقة مع ملخص الفيديو
     */
    public function summary(): HasOne
    {
        return $this->hasOne(VideoSummary::class);
    }
}
