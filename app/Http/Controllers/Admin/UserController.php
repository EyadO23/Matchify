<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;

class UserController extends Controller
{
    /**
     * عرض كل المستخدمين (غير الأدمن)
     */
    public function index(): JsonResponse
    {
        return response()->json(
            User::where('role', 'user')->get()
        );
    }

    /**
     * حظر مستخدم (بدون حذف أي بيانات)
     */
    public function block($id): JsonResponse
    {
        $user = User::findOrFail($id);

        if ($user->role === 'admin') {
            return response()->json([
                'success' => false,
                'message' => 'لا يمكن حظر أدمن'
            ], 403);
        }

        $user->update([
            'role' => 'blocked'
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم حظر المستخدم بنجاح'
        ]);
    }

    /**
     * فك حظر مستخدم
     */
    public function unblock($id): JsonResponse
    {
        $user = User::findOrFail($id);

        if ($user->role !== 'blocked') {
            return response()->json([
                'success' => false,
                'message' => 'المستخدم غير محظور'
            ], 400);
        }

        $user->update([
            'role' => 'user'
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم فك الحظر عن المستخدم'
        ]);
    }

    public function blockedUsers(): JsonResponse
    {
        // جلب كل المستخدمين المحظورين
        $blockedUsers = User::where('role', 'blocked')->get();

        if ($blockedUsers->isEmpty()) {
            return response()->json([
                'success' => true,
                'message' => 'لا يوجد مستخدمون محظورون',
                'count' => 0,
                'users' => []
            ]);
        }

        return response()->json([
            'success' => true,
            'count' => $blockedUsers->count(),
            'users' => $blockedUsers
        ]);
    }

    /**
     * تقارير الفيديوهات لمستخدم معين (للأدمن)
     * بدون Redis – فقط من DB
     */
    public function SummaryReports($userId): JsonResponse
    {
        $user = User::findOrFail($userId);

        $videos = $user->videos()
            ->with('summary')
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($video) {
                return [
                    'video_id'          => $video->id,
                    'summary_type'      => $video->summary_type,
                    'processing_status' => $video->processing_status,
                    'duration_seconds'  => $video->duration_seconds,
                    'created_at'        => $video->created_at,

                    // بيانات الملخص إن وُجد
                    'summary' => $video->summary ? [
                        'highlight_path'   => $video->summary->storage_path,
                        'confidence_score' => $video->summary->confidence_score,
                        'segments'         => json_decode($video->summary->segments, true),
                    ] : null,
                ];
            });

        return response()->json([
            'user_id'   => $user->id,
            'user_name' => $user->name,
            'videos'    => $videos,
        ]);
    }
}

   