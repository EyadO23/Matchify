<?php



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