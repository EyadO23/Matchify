<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Http\Controllers\Filttercontroller;

class Filtter extends Model
{
    //
    protected $fillable = [
        'url',
        'filter_type',
        'player_name',
        'summary_type'
    ];
}
