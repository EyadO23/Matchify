<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Team;

class FavoriteTeamController extends Controller
{
    //  GET: جلب الفرق المفضلة للمستخدم
    public function index(Request $request)
    {
        $user = $request->user();

        $favoriteTeams = $user->favoriteTeams()->get();

        $formattedTeams = $favoriteTeams->map(function ($team) {
            return [
                'team_id' => $team->team_id,  
                'team_name' => $team->name,
                'logo_url' => $team->logo_url,
                'added_at' => $team->pivot->created_at ?? null
            ];
        });

        return response()->json([
            'favorite_teams' => $formattedTeams
        ]);
    }

    // 🔹 POST: إضافة فريق مفضل جديد
    public function store(Request $request)
    {
        $request->validate([
            'team_id' => 'required|exists:teams,team_id'  
        ]);

        $user = $request->user();

        // التحقق إذا الفريق مضاف مسبقاً
        $exists = $user->favoriteTeams()
            ->where('teams.team_id', $request->team_id)  
            ->exists();

        if ($exists) {
            return response()->json([
                'message' => 'الفريق مضاف مسبقاً إلى المفضلة'
            ], 409);
        }

        // إضافة الفريق للمفضلة
        $user->favoriteTeams()->attach($request->team_id);

        $team = Team::where('team_id', $request->team_id)->first();  

        return response()->json([
            'message' => 'تمت إضافة الفريق إلى المفضلة بنجاح',
            'team' => [
                'team_id' => $team->team_id,  
                'name' => $team->name,
                'logo_url' => $team->logo_url
            ]
        ], 201);
    }

     public function updateMultiple(Request $request)
{
    $request->validate([
        'new_team_ids' => 'required|array|min:1',
        'new_team_ids.*' => 'exists:teams,team_id'
    ]);

    $user = $request->user();
    $newTeamIds = $request->new_team_ids;

    // جلب الفرق الحالية
    $currentFavoriteTeams = $user->favoriteTeams()->pluck('teams.team_id')->toArray();
    
    // إذا كانت الفرق الجديدة هي نفس الفرق الحالية (بنفس الترتيب)
    sort($currentFavoriteTeams);
    $sortedNewTeamIds = $newTeamIds;
    sort($sortedNewTeamIds);
    
    if ($currentFavoriteTeams === $sortedNewTeamIds) {
        return response()->json([
            'message' => 'الفرق الجديدة هي نفس الفرق الحالية'
        ], 400);
    }

    // 1. حذف جميع الفرق القديمة
    $removedCount = $user->favoriteTeams()->detach();

    // 2. إضافة الفرق الجديدة
    foreach ($newTeamIds as $teamId) {
        $user->favoriteTeams()->attach($teamId);
    }

    // 3. جلب بيانات الفرق الجديدة
    $newTeams = Team::whereIn('team_id', $newTeamIds)->get();

    return response()->json([
        'message' => 'تم تحديث الفرق المفضلة بنجاح',
        'old_teams_removed' => $removedCount,
        'new_teams' => $newTeams->map(function ($team) {
            return [
                'team_id' => $team->team_id,
                'name' => $team->name,
                'logo_url' => $team->logo_url
            ];
        }),
        'favorite_teams_count' => count($newTeamIds)
    ]);
}
    //  DELETE: حذف فريق من المفضلة
    public function destroy(Request $request, $teamId)
    {
        $user = $request->user();

        $detached = $user->favoriteTeams()->detach($teamId);

        if ($detached > 0) {
            return response()->json([
                'message' => 'تم إزالة الفريق من المفضلة'
            ]);
        }

        return response()->json([
            'message' => 'الفريق غير موجود في المفضلة'
        ], 404);
    }

    //  GET: جلب قائمة جميع الفرق المتاحة
    public function availableTeams(Request $request)
    {
        $teams = Team::orderBy('name')->get(['team_id', 'name', 'logo_url']);

        return response()->json([
            'teams' => $teams
        ]);
    }

    //  GET: جلب فريق معين بالتفاصيل
    public function show($teamId)
    {
        $team = Team::where('team_id', $teamId)->first();

        if (!$team) {
            return response()->json([
                'message' => 'الفريق غير موجود'
            ], 404);
        }

        return response()->json([
            'team' => [
                'team_id' => $team->team_id,
                'name' => $team->name,
                'logo_url' => $team->logo_url
            ]
        ]);
    }

    public function storeMultiple(Request $request)
    {
        $request->validate([
            'team_ids' => 'required|array',
            'team_ids.*' => 'exists:teams,team_id'
        ]);

        $user = $request->user();
        $addedTeams = [];
        
        foreach ($request->team_ids as $teamId) {
            // التحقق إذا الفريق مضاف مسبقاً
            if (!$user->favoriteTeams()->where('teams.team_id', $teamId)->exists()) {
                $user->favoriteTeams()->attach($teamId);
                $team = Team::where('team_id', $teamId)->first();
                $addedTeams[] = $team;
            }
        }
        
        return response()->json([
            'message' => 'تمت إضافة ' . count($addedTeams) . ' فريق',
            'teams' => $addedTeams
        ]);
    }
}