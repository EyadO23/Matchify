<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FavoriteTeam extends Model
{
     protected $fillable = ['user_id', 'team'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
