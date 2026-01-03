<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

// // class NewsService
// // {
// //     public function getTeamNews(string $team): string
// //     {
// //         $response = Http::get('https://newsapi.org/v2/everything', [
// //             'q' => $team,
// //             'sortBy' => 'publishedAt',
// //             'language' => 'en',
// //             'pageSize' => 5,
// //             'apiKey' => env('NEWS_API_KEY'),
// //         ]);

// //         if (!$response->successful()) {
// //             return '';
// //         }

// //         return collect($response->json('articles'))
// //             ->map(fn ($a) => "- {$a['title']}")
// //             ->implode("\n");
// //     }
// // }

class NewsService
{
    public function getTeamNews(string $team): array
    {
        $response = Http::get('https://newsapi.org/v2/everything', [
            'q' => $team,
            'sortBy' => 'publishedAt',
            'language' => 'ar',
            'pageSize' => 5,
            'apiKey' => env('NEWS_API_KEY'),
        ]);

        if ($response->failed()) {
            return [];
        }

        return collect($response->json('articles', []))
            ->map(fn ($a) => [
                'title' => $a['title'] ?? '',
                'publishedAt' => $a['publishedAt'] ?? '',
                'source' => $a['source']['name'] ?? '',
            ])
            ->toArray();
    }
} 




// // App\Services\NewsService.php
// class NewsService
// {
//     public function getTeamNews(string $team): array
//     {
//         $response = Http::get('https://newsapi.org/v2/everything', [
//             'q' => $team,
//             'sortBy' => 'publishedAt',
//             'language' => 'ar',
//             'pageSize' => 10,
//             'apiKey' => env('NEWS_API_KEY'),
//         ]);

//         if ($response->failed()) {
//             return [];
//         }

//         return collect($response->json('articles', []))
//             ->map(fn ($a) => [
//                 'title' => $a['title'] ?? '',
//             ])
//             ->filter(fn ($a) => $a['title'] !== '')
//             ->values()
//             ->toArray();
//     }
// }



// namespace App\Services;

// use Illuminate\Support\Facades\Http;

// class NewsService
// {
//     public function getTeamNews(string $team): array
//     {
//         $response = Http::get('https://newsapi.org/v2/everything', [
//             'q' => $team,
//             'language' => 'ar',
//             'sortBy' => 'publishedAt',
//             'pageSize' => 10,
//             'apiKey' => env('NEWS_API_KEY'),
//         ]);

//         if ($response->failed()) {
//             return [];
//         }

//         return collect($response->json('articles', []))
//             ->map(fn ($a) => [
//                 'title' => $a['title'] ?? '',
//             ])
//             ->filter(fn ($a) => $a['title'] !== '')
//             ->values()
//             ->toArray();
//     }
// }
