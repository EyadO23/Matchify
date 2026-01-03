<?php

// namespace App\Services;

// use Illuminate\Support\Facades\Http;

// class AiService
// {
//     public function summarizeNews(string $team, array $news): string
//     {
//         if (empty($news)) {
//             return 'لا توجد أخبار للتلخيص.';
//         }

//         // تجهيز الأخبار بشكل منظم
//         $formattedNews = collect($news)->map(function ($item, $index) {
//             return ($index + 1) . ". {$item['title']} ("
//                 . date('Y-m-d', strtotime($item['publishedAt'])) . ")";
//         })->implode("\n");

//         // Prompt صارم بأسلوب خبري
//         $prompt = <<<TEXT
// اكتب خبراً رياضياً قصيراً عن نادي {$team} فقط.

// التزم حرفياً:
// - لا تستخدم "نستعرض" أو "نعرض"
// - لا تذكر تويتر أو مواقع أو منصات
// - لا تشرح ولا تعرّف
// - لا تتحدث عن الأخبار نفسها
// - لا تذكر فرق أخرى
// - جمل خبرية مباشرة
// - 2 جمل فقط

// العناوين:
// {$formattedNews}

// الخبر:
// TEXT;

//         $response = Http::withHeaders([
//             'Authorization' => 'Bearer ' . env('HF_API_KEY'),
//             'Content-Type' => 'application/json',
//         ])->post(
//             'https://router.huggingface.co/hf-inference/models/csebuetnlp/mT5_multilingual_XLSum',
//             [
//                 'inputs' => $prompt,
//                 'parameters' => [
//                     'max_length' => 160,
//                     'min_length' => 80,
//                     'do_sample' => false,
//                 ],
//             ]
//         );

//         if ($response->failed()) {
//             return 'فشل الاتصال بخدمة التلخيص';
//         }

//         $data = $response->json();
//         $summary = $data[0]['summary_text'] ?? '';

//         return $this->forceClean($summary);
//     }

//     /**
//      * تنظيف إجباري للنص وإزالة الأسلوب غير الصحفي
//      */
//     private function forceClean(string $text): string
//     {
//         $bannedWords = [
//             'نعرض',
//             'نستعرض',
//             'تويتر',
//             'فيسبوك',
//             'منصة',
//             'موقع',
//             'الإنترنت',
//             'هذا الخبر',
//             'هذه الأخبار',
//             'العناوين',
//             'تلخيص',
//             'آلي',
//         ];

//         $text = str_replace($bannedWords, '', $text);

//         // استخراج أول جملتين فقط
//         $sentences = preg_split('/[.!؟]/u', $text);
//         $sentences = array_filter(array_map('trim', $sentences));

//         return implode('، ', array_slice($sentences, 0, 2)) . '.';
//     }
// }



namespace App\Services;

use Illuminate\Support\Facades\Http;

class AiService
{
    /**
     * إنشاء خبر رياضي قصير عن فريق معيّن
     */
    public function summarizeNews(string $team, array $news): string
    {
        if (empty($news)) {
            return 'لا توجد أخبار حديثة عن هذا الفريق.';
        }

        // نحول العناوين لنص خبري بسيط (مناسب لموديل تلخيص)
        $newsText = collect($news)
            ->pluck('title')
            ->implode('، ');

        $prompt = <<<TEXT
{$newsText}
TEXT;

        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . env('HF_API_KEY'),
            'Content-Type' => 'application/json',
        ])->post(
            'https://router.huggingface.co/hf-inference/models/csebuetnlp/mT5_multilingual_XLSum',
            [
                'inputs' => $prompt,
                'parameters' => [
                    'max_length' => 120,
                    'min_length' => 60,
                    'do_sample' => false,
                ],
            ]
        );

        if ($response->failed()) {
            return 'تعذّر توليد الخبر حالياً.';
        }

        $data = $response->json();

        $summary = $data[0]['summary_text'] ?? '';

        return $this->cleanNewsStyle($summary);
    }

    /**
     * تنظيف النص ليطلع خبري ومقروء
     */
    private function cleanNewsStyle(string $text): string
    {
        $banned = [
            'نستعرض',
            'نعرض',
            'هذا الخبر',
            'هذه الأخبار',
            'العناوين',
            'تلخيص',
            'آلي',
            'الإنترنت',
            'من خلال',
            'مواقع التواصل',
            'تويتر',
            'فيسبوك',
        ];

        $text = trim(str_replace($banned, '', $text));

        // ناخد أول جملتين فقط
        $sentences = preg_split('/[.!؟]/u', $text);
        $sentences = array_filter(array_map('trim', $sentences));

        if (count($sentences) >= 2) {
            return $sentences[0] . '، ' . $sentences[1] . '.';
        }

        return $sentences[0] . '.';
    }
}

/*namespace App\Services;

use Illuminate\Support\Facades\Http;

class AiService
{
    public function rewrite(string $team, string $topic, array $titles): string
    {
        $list = implode('، ', $titles);

        $prompt = <<<TEXT
أنت محرر أخبار رياضية.
أعد صياغة العناوين التالية عن {$team} بصيغة خبرية محايدة.
لا تضف معلومات جديدة.
جملة واحدة أو جملتين فقط.

العناوين:
{$list}
TEXT;

        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . env('HF_API_KEY'),
            'Content-Type' => 'application/json',
        ])->post(
            'https://router.huggingface.co/hf-inference/models/csebuetnlp/mT5_multilingual_XLSum',
            [
                'inputs' => $prompt,
                'parameters' => [
                    'max_length' => 80,
                    'do_sample' => false,
                ],
            ]
        );

        if ($response->failed()) {
            return '';
        }

        return trim($response->json()[0]['summary_text'] ?? '');
    }
}*/
