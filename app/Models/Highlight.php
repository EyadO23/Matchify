<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Highlight extends Model
{
    protected $fillable = [
        'user_id','job_id','clips_dir','summary_type','summary_length','threshold','result','storage_path'
    ];

    protected $casts = [
        'result' => 'array',
    ];

    
public function user()
{
    return $this->belongsTo(User::class);
}

}
