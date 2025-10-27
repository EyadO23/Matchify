<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Filttercontroller;
use App\Models\Filtter;

Route::post( [Filttercontroller::class, 'store']);