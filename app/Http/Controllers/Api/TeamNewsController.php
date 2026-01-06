<?php

// namespace App\Http\Controllers\Api;

// use App\Http\Controllers\Controller;
// use Illuminate\Http\Request;
// use Illuminate\Support\Facades\Http;
// use App\Services\NewsService;
// use App\Services\AiService;

// class TeamNewsController extends Controller
// {
//     public function summarize(
//         Request $request,
//         NewsService $newsService,
//         AiService $aiService
//     ) {
//         $team = $request->input('team');

//         if (!$team) {
//             return response()->json(['error' => 'اسم الفريق مطلوب'], 400);
//         }

//         $articles = $newsService->getTeamNews($team);

//         if (empty($articles)) {
//             return response()->json([
//                 'team' => $team,
//                 'summary' => 'لا توجد أخبار حديثة عن هذا الفريق.',
//                 'articles' => [],
//             ]);
//         }

//         $summary = $aiService->summarizeNews($team, $articles);

//         return response()->json([
//             'team' => $team,
//             'articles' => $articles,
//             'summary' => $summary,
//         ]);
//     }
// }


namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\NewsService;
use App\Models\Team;

class TeamNewsController extends Controller
{
    public function getTeamNews(Request $request, NewsService $newsService)
    {
        $teamId = $request->input('team_id');
        
        if (!$teamId) {
            return response()->json(['error' => 'معرف الفريق مطلوب'], 400);
        }
        
        $team = Team::where('team_id', $teamId)->first();
        
        if (!$team) {
            return response()->json(['error' => 'الفريق غير موجود'], 404);
        }
        
        // ⚡ نفس الاستدعاء القديم
        $articles = $newsService->getTeamNews($team->name);
        
        return response()->json([
            'team_id' => $team->team_id,
            'team_name' => $team->name,
            'team_logo' => $team->logo_url,
            'articles' => $articles,
            'articles_count' => count($articles)
        ]);
    }

    public function getFavoriteTeamsNews(Request $request, NewsService $newsService)
    {
        $user = $request->user();
        
        // جلب الفرق المفضلة للمستخدم
        $favoriteTeams = $user->favoriteTeams()->get();
        
        if ($favoriteTeams->isEmpty()) {
            return response()->json([
                'message' => 'لا توجد فرق مفضلة',
                'articles' => [],
                'total_articles' => 0
            ], 200);
        }
        
        $allArticles = [];
        
        // جلب أخبار كل فريق باستخدام نفس الاستدعاء القديم
        foreach ($favoriteTeams as $team) {
            $articles = $newsService->getTeamNews($team->name);
            
            // إضافة معلومات الفريق لكل مقالة (بنفس نمط الدالة الأصلية)
            foreach ($articles as $article) {
                $allArticles[] = [
                    ...$article, // نشر محتوى المقالة الأصلي
                    'team_id' => $team->team_id,
                    'team_name' => $team->name,
                    'team_logo' => $team->logo_url
                ];
            }
        }
        
        // ترتيب المقالات من الأحدث إلى الأقدم
        usort($allArticles, function ($a, $b) {
            $dateA = $a['published_at'] ?? $a['date'] ?? $a['pubDate'] ?? '1970-01-01';
            $dateB = $b['published_at'] ?? $b['date'] ?? $b['pubDate'] ?? '1970-01-01';
            return strtotime($dateB) - strtotime($dateA);
        });
        
        return response()->json([
            'articles' => $allArticles,
            'total_articles' => count($allArticles)
        ]);
    }
}