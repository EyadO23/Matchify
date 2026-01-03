<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\FavoriteTeam;

class FavoriteTeamController extends Controller
{
    // 🔹 جلب الفريق المفضل لليوزر
    public function show(Request $request)
    {
        $user = $request->user();

        $favorite = $user->favoriteTeam;

        return response()->json([
            'team' => $favorite?->team
        ]);
    }

    // 🔹 إنشاء أو تعديل الفريق
    public function store(Request $request)
    {
        $request->validate([
            'team' => 'required|string|max:100'
        ]);

        $user = $request->user();

        $favorite = FavoriteTeam::updateOrCreate(
            ['user_id' => $user->id],
            ['team' => $request->team]
        );

        return response()->json([
            'message' => 'Favorite team saved',
            'team' => $favorite->team
        ]);
    }
}

