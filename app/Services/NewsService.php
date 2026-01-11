<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Cache;

class NewsService
{
    public function getTeamNews(string $team): array
    {
        //  مفتاح التخزين المؤقت لكل فريق
        $cacheKey = 'team_news_' . md5($team);

        //  تخزين الأخبار لمدة ساعتين (7200 ثانية)
        return Cache::remember($cacheKey, 7200, function () use ($team) {

            //  ترجمة جميع الفرق من العربية إلى الإنجليزية
            $englishTeam = $this->translateTeamToEnglish($team);
            
            //  بحث بـ "football" لتحسين النتائج
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
        });
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

