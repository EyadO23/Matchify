<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
// // use App\Services\AiService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

// // class TeamNewsController extends Controller
// // {
// //     public function summarize(Request $request, AiService $ai)
// //     {
// //         $team = $request->input('team');

// //         try {
// //             $apiKey = env('NEWS_API_KEY'); // مفتاح API
// //             $languages = ['ar', 'en']; // جرب العربية أولًا ثم الإنجليزية

// //             $articles = [];

// //             foreach ($languages as $lang) {
// //                 $response = Http::get("https://newsapi.org/v2/everything", [
// //                     'q' => $team,
// //                     'language' => $lang,
// //                     'sortBy' => 'publishedAt',
// //                     'apiKey' => $apiKey
// //                 ]);

// //                 $data = $response->json();

// //                 if (!empty($data['articles'])) {
// //                     $articles = collect($data['articles'])->map(fn($a) => $a['title'])->toArray();
// //                     break; // وجدنا الأخبار، نوقف اللوب
// //                 }
// //             }

// //             if (empty($articles)) {
// //                 return response()->json([
// //                     'team' => $team,
// //                     'summary' => 'لم يتم العثور على أخبار لهذا الفريق حالياً.'
// //                 ]);
// //             }

// //             // تلخيص الأخبار باستخدام AI
// //             $summary = $ai->summarizeNews($team, $articles);

// //             return response()->json([
// //                 'team' => $team,
// //                 'summary' => $summary,
// //                 'articles' => $articles
// //             ]);

// //         } catch (\Exception $e) {
// //             return response()->json([
// //                 'error' => 'حدث خطأ: ' . $e->getMessage()
// //             ], 500);
// //         }
// //     }
// // }




// // namespace App\Http\Controllers\Api;

// // use App\Http\Controllers\Controller;
// // use App\Services\AiService;
// // use Illuminate\Http\Request;
// // use Illuminate\Support\Facades\Http;

// // class TeamNewsController extends Controller
// // {
// //     protected AiService $ai;

// //     public function __construct(AiService $ai)
// //     {
// //         $this->ai = $ai;
// //     }

// //     public function summarize(Request $request, AiService $ai)
// // {
// //     $team = $request->input('team');

// //     if (!$team) {
// //         return response()->json(['error' => 'اسم الفريق مطلوب'], 400);
// //     }

// //     $response = Http::get('https://newsapi.org/v2/everything', [
// //         'q' => $team,
// //         'language' => 'en', // ⚠️ مهم
// //         'apiKey' => env('NEWS_API_KEY'),
// //         'pageSize' => 5,
// //     ]);

// //     $articles = collect($response->json()['articles'] ?? [])
// //         ->pluck('title')
// //         ->toArray();

// //     $summary = $ai->summarizeNews($team, $articles);

// //     return response()->json([
// //         'team' => $team,
// //         'articles' => $articles,
// //         'summary' => $summary,
// //     ]);
// // }
// // }




// namespace App\Http\Controllers\Api;

// use App\Http\Controllers\Controller;
// use Illuminate\Http\Request;


// // namespace App\Http\Controllers\Api;

// // use App\Http\Controllers\Controller;
// // // use App\Services\AiService;
// // use Illuminate\Http\Request;
// // use Illuminate\Support\Facades\Http;

// // class TeamNewsController extends Controller
// // {
// //     public function summarize(Request $request, AiService $ai)
// //     {
// //         $team = $request->input('team');

// //         if (!$team) {
// //             return response()->json(['error' => 'يجب إدخال اسم الفريق'], 400);
// //         }

// //         $apiKey = env('NEWS_API_KEY');
// //         $response = Http::get("https://newsapi.org/v2/everything", [
// //             'q' => $team,
// //             'language' => 'ar',
// //             'sortBy' => 'publishedAt',
// //             'apiKey' => $apiKey,
// //             'pageSize' => 5,
// //         ]);

// //         $articles = collect($response->json()['articles'] ?? [])
// //     ->map(function ($article) {
// //         return [
// //             'title' => $article['title'] ?? '',
// //             'publishedAt' => $article['publishedAt'] ?? '',
// //             'source' => $article['source']['name'] ?? '',
// //         ];
// //     })
// //     ->toArray();


// //         $summary = $ai->summarizeNews($team, $articles);

// //         return response()->json([
// //             'team' => $team,
// //             'articles' => $articles,
// //             'summary' => $summary,
// //         ]);
// //     }
// // }


// use App\Services\NewsService;
// use App\Services\AiService;
// use App\Services\NewsDigest\DigestBuilder;

// class TeamNewsController extends Controller
// {
//     public function digest(
//         Request $request,
//         NewsService $newsService,
//         DigestBuilder $digestBuilder,
//         AiService $aiService
//     ) {
//         $team = $request->input('team');
//         if (!$team) {
//             return response()->json(['error' => 'اسم الفريق مطلوب'], 400);
//         }

//         $articles = $newsService->getTeamNews($team);

//         $digest = $digestBuilder->build($articles);

//         $finalDigest = [];

//         foreach ($digest as $topic => $titles) {
//             if (empty($titles)) continue;

//             $finalDigest[$topic] = $aiService->rewrite(
//                 $team,
//                 $topic,
//                 $titles
//             );
//         }

//         return response()->json([
//             'team' => $team,
//             'digest' => $finalDigest,
//         ]);
//     }
// }




// namespace App\Http\Controllers\Api;

// use App\Http\Controllers\Controller;
// use Illuminate\Http\Request;
// use App\Services\NewsService;
// use App\Services\AiService;
// use App\Services\NewsDigest\DigestBuilder;

// class TeamNewsController extends Controller
// {
//     public function digest(
//         Request $request,
//         NewsService $newsService,
//         DigestBuilder $digestBuilder,
//         AiService $aiService
//     ) {
        
//         $team = $request->input('team');

//         if (!$team) {
//             return response()->json(['error' => 'اسم الفريق مطلوب'], 400);
//         }

//         $articles = $newsService->getTeamNews($team);
//         $digest = $digestBuilder->build($articles);

//         $finalDigest = [];

//         foreach ($digest as $topic => $titles) {
//             if (empty($titles)) continue;

//             $finalDigest[$topic] = $aiService->rewrite(
//                 $team,
//                 $topic,
//                 $titles
//             );
//         }

//         return response()->json([
//             'team' => $team,
//             'digest' => $finalDigest,
//         ]);
//     }
// }

use App\Services\NewsService;
use App\Services\AiService;

class TeamNewsController extends Controller
{
    public function summarize(
        Request $request,
        NewsService $newsService,
        AiService $aiService
    ) {
        $team = $request->input('team');

        if (!$team) {
            return response()->json(['error' => 'اسم الفريق مطلوب'], 400);
        }

        $articles = $newsService->getTeamNews($team);

        if (empty($articles)) {
            return response()->json([
                'team' => $team,
                'summary' => 'لا توجد أخبار حديثة عن هذا الفريق.',
                'articles' => [],
            ]);
        }

        $summary = $aiService->summarizeNews($team, $articles);

        return response()->json([
            'team' => $team,
            'articles' => $articles,
            'summary' => $summary,
        ]);
    }
}
