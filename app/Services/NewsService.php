<?php


namespace App\Services;

use Illuminate\Support\Facades\Http;

class NewsService
{
    public function getTeamNews(string $team): array
    {
        // 🔹 ترجمة جميع الفرق من العربية إلى الإنجليزية
        $englishTeam = $this->translateTeamToEnglish($team);
        
        // 🔹 بحث بـ "football" لتحسين النتائج
        $query = $englishTeam . ' football';
        
        $response = Http::get('https://newsapi.org/v2/everything', [
            'q' => $query,
            'sortBy' => 'publishedAt',
            'language' => 'ar',
            'pageSize' => 10,
            'apiKey' => env('NEWS_API_KEY'),
        ]);

        // 🔹 إذا فشل، جرب بدون "football"
        if ($response->failed() || empty($response->json('articles'))) {
            $response = Http::get('https://newsapi.org/v2/everything', [
                'q' => $englishTeam,
                'sortBy' => 'publishedAt',
                'language' => 'ar',
                'pageSize' => 10,
                'apiKey' => env('NEWS_API_KEY'),
            ]);
        }

        if ($response->failed()) {
            \Log::error('NewsAPI failed for: ' . $team . ' (translated: ' . $englishTeam . ')');
            return [];
        }

        $articles = $response->json('articles', []);
        
        \Log::info('News found for ' . $team . ': ' . count($articles) . ' articles');

        return collect($articles)
            ->map(fn ($article) => [
                'title' => $article['title'] ?? 'بدون عنوان',
                'description' => $article['description'] ?? '',
                'published_at' => $article['publishedAt'] ?? now()->toDateTimeString(),
                'source' => $article['source']['name'] ?? 'مصدر غير معروف',
                'url' => $article['url'] ?? '#',
                'image_url' => $article['urlToImage'] ?? null,
                'content' => $article['content'] ?? '',
            ])
            ->toArray();
    }

    // 🔹 دالة ترجمة كاملة لجميع الفرق في السيدر
    private function translateTeamToEnglish(string $arabicName): string
    {
        $translations = [
            // الدوري الإسباني
            'برشلونة' => 'Barcelona',
            'ريال مدريد' => 'Real Madrid',
            'أتلتيكو مدريد' => 'Atletico Madrid',
            'إشبيلية' => 'Sevilla',
            'فالنسيا' => 'Valencia',
            'فياريال' => 'Villarreal',
            'ريال بيتيس' => 'Real Betis',
            'ريال سوسيداد' => 'Real Sociedad',
            'أتلتيك بيلباو' => 'Athletic Bilbao',
            
            // الدوري الإنجليزي
            'مانشستر يونايتد' => 'Manchester United',
            'مانشستر سيتي' => 'Manchester City',
            'ليفربول' => 'Liverpool',
            'تشيلسي' => 'Chelsea',
            'أرسنال' => 'Arsenal',
            'توتنهام هوتسبر' => 'Tottenham Hotspur',
            'نيوكاسل يونايتد' => 'Newcastle United',
            'وست هام يونايتد' => 'West Ham United',
            'إيفرتون' => 'Everton',
            'أستون فيلا' => 'Aston Villa',
            
            // الدوري الإيطالي
            'يوفنتوس' => 'Juventus',
            'إنتر ميلان' => 'Inter Milan',
            'ميلان' => 'AC Milan',
            'نابولي' => 'Napoli',
            'روما' => 'AS Roma',
            'لاتسيو' => 'Lazio',
            'أتالانتا' => 'Atalanta',
            'فيورنتينا' => 'Fiorentina',
            
            // الدوري الألماني
            'بايرن ميونخ' => 'Bayern Munich',
            'بوروسيا دورتموند' => 'Borussia Dortmund',
            'باير ليفركوزن' => 'Bayer Leverkusen',
            'لايبزيغ' => 'RB Leipzig',
            'آينتراخت فرانكفورت' => 'Eintracht Frankfurt',
            'بوروسيا مونشنجلادباخ' => 'Borussia Monchengladbach',
            'فولفسبورغ' => 'VfL Wolfsburg',
            'شالكه 04' => 'Schalke 04',
            
            // الدوري الفرنسي
            'باريس سان جيرمان' => 'Paris Saint-Germain',
            'موناكو' => 'AS Monaco',
            'مارسيليا' => 'Marseille',
            'ليون' => 'Lyon',
            'ليل' => 'Lille',
            'نيس' => 'Nice',
            'رين' => 'Rennes',
            
            // الدوري البرتغالي
            'بنفيكا' => 'Benfica',
            'بورتو' => 'Porto',
            'سبورتينغ لشبونة' => 'Sporting Lisbon',
            
            // الدوري الهولندي
            'أياكس' => 'Ajax',
            'آيندهوفن' => 'PSV Eindhoven',
            'فينورد' => 'Feyenoord',
            
            // فرق عربية
            'الهلال' => 'Al Hilal',
            'النصر' => 'Al Nassr',
            'الأهلي' => 'Al Ahli',
            'الاتحاد' => 'Al Ittihad',
            'الزمالك' => 'Zamalek',
            'الأهلي المصري' => 'Al Ahly',
            'الرجاء' => 'Raja Casablanca',
            'الوداد' => 'Wydad Casablanca',
            
            // فرق أوروبية إضافية
            'سلتيك' => 'Celtic',
            'رينجرز' => 'Rangers',
            'غلطة سراي' => 'Galatasaray',
            'فنربخشة' => 'Fenerbahce',
            'بشكتاش' => 'Besiktas',
            'شاختار دونيتسك' => 'Shakhtar Donetsk',
            'دينامو كييف' => 'Dynamo Kyiv',
            
            // فرق أمريكية
            'لوس أنجلوس جلاكسي' => 'LA Galaxy',
            'إنتر ميامي' => 'Inter Miami',
            'نيويورك سيتي' => 'NYC FC',
            
            // منتخبات وطنية
            'الأرجنتين' => 'Argentina',
            'البرازيل' => 'Brazil',
            'فرنسا' => 'France',
            'إنجلترا' => 'England',
            'ألمانيا' => 'Germany',
            'إيطاليا' => 'Italy',
            'إسبانيا' => 'Spain',
            'المغرب' => 'Morocco',
            'مصر' => 'Egypt',
            'السعودية' => 'Saudi Arabia',
        ];

        return $translations[$arabicName] ?? $arabicName;
    }
}
// namespace App\Services;

// use Illuminate\Support\Facades\Http;

// class NewsService
// {
//     public function getTeamNews(string $team): array
//     {
//         // ⚡ الكود القديم نفسه بالضبط
//         $response = Http::get('https://newsapi.org/v2/everything', [
//             'q' => $team,                      // نفس الكود
//             'sortBy' => 'publishedAt',         // نفس الكود
//             'language' => 'ar',                // نفس الكود
//             'pageSize' => 5,                   // نفس الكود
//             'apiKey' => env('NEWS_API_KEY'),   // نفس الكود
//         ]);

//         if ($response->failed()) {
//             return [];
//         }

//         // نفس الكود مع تعديل بسيط
//         return collect($response->json('articles', []))
//             ->map(fn ($a) => [
//                 'title' => $a['title'] ?? '',
//                 'publishedAt' => $a['publishedAt'] ?? '',
//                 'source' => $a['source']['name'] ?? '',
//                 // ⚡ بس أضفنا هذين الحقلين
//                 'url' => $a['url'] ?? '',
//                 'image_url' => $a['urlToImage'] ?? null,
//             ])
//             ->toArray();
//     }
// }

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

//// هاد كان اخر واحد 
// class NewsService
// {
//     public function getTeamNews(string $team): array
//     {
//         $response = Http::get('https://newsapi.org/v2/everything', [
//             'q' => $team,
//             'sortBy' => 'publishedAt',
//             'language' => 'ar',
//             'pageSize' => 5,
//             'apiKey' => env('NEWS_API_KEY'),
//         ]);

//         if ($response->failed()) {
//             return [];
//         }

//         return collect($response->json('articles', []))
//             ->map(fn ($a) => [
//                 'title' => $a['title'] ?? '',
//                 'publishedAt' => $a['publishedAt'] ?? '',
//                 'source' => $a['source']['name'] ?? '',
//             ])
//             ->toArray();
//     }
// } 




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
