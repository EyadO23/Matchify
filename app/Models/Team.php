<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Team extends Model
{
    use HasFactory;

    protected $primaryKey = 'team_id';
    public $timestamps = true;

    protected $fillable = ['name', 'logo_url'];

     public function favoriteUsers()
    {
        return $this->belongsToMany(
            User::class,
            'favorite_teams',
            'team_id',
            'user_id'
        )->withTimestamps();
    }
}