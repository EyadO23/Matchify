<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;
use DOMDocument;
use App\Models\Filtter;
use Illuminate\Support\Facades\Log;

class Filttercontroller extends Controller
{
     /**
     * كلمات مفتاحية تدل على أن المحتوى مرتبط بكرة القدم
     */
    protected array $footballKeywords = [
        // عربي
        'مباراة', 'كرة قدم', 'اهداف', 'هجمات خطيرة', 'شوط', 'ملخص', 'ديربي',
        'ريال مدريد', 'برشلونة', 'الدوري الإنجليزي', 'الدوري السعودي', 'كأس العالم',
        'فريق', 'لاعب', 'هداف', 'مرمى', 'ركلة جزاء', 'بطولة', 'منتخب',
        'الاهلي', 'الزمالك', 'الهلال', 'الاتحاد', 'النصر', 'الشباب',
        'شباك نظيفة', 'بطاقة حمراء', 'بطاقة صفراء', 'VAR',

        // إنجليزي (لأن العناوين غالبًا مختلطة)
        'football', 'soccer', 'match', 'goals', 'highlights', 'vs', 'versus',
        'premier league', 'la liga', 'champions league', 'world cup', 'team',
        'goal', 'attack', 'full match', 'extended highlights', 'derby',
        'real madrid', 'barcelona', 'manchester', 'liverpool', 'arsenal'
    ];

    /**
     * استقبال الرابط والتحقق منه
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'url' => 'required|url',
            'type' => 'required|in:اهداف, بطاقة حمراء,لقطات لاعب معين,بطاقة صفراء"',
            'summary_type' => 'required|in:طويل,قصير',
            'player_name' => 'nullable|string|max:100',
        ], [
            'url.required' => 'الرابط مطلوب',
            'url.url' => 'الرجاء إدخال رابط صحيح',
            'type.required' => 'نوع المقطع مطلوب',
            'type.in' =>  'النوع يجب أن يكون "اهداف" أو "بطاقات حمراء "او "لقطات لاعب معين" أو "بطاقة صفراء"' ,
            'summary_type.required' => 'نوع الملخص مطلوب',
            'summary_type.in' => 'نوع الملخص : طويل او قصير',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'بيانات غير صالحة',
                'errors' => $validator->errors()
            ], 422);
        }

        $url = $request->url;

        // استخراج النص (عنوان + وصف) من الرابط
        $textContent = $this->extractTextFromUrl($url);

        if (!$textContent) {
            return response()->json([
                'success' => false,
                'message' => 'لا يمكن استخراج معلومات من هذا الرابط. تأكد أنه لفيديو أو مباراة.'
            ], 422);
        }
           // التحقق الشرطي: إذا كان filter_type = لقطات لاعب معين، يجب أن يُدخل player_name
        $validator->sometimes('player_name', 'required|string|max:100', function ($input) {
            return $input->type === 'لقطات لاعب معين';
        });

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }


        // التحقق من أن النص مرتبط بكرة القدم
        if (!$this->isFootballRelated($textContent)) {
            return response()->json([
                'success' => false,
                'message' => 'يبدو أن هذا الرابط لا يخص مباراة كرة قدم. يُسمح فقط بمحتوى كرة القدم.'
            ], 422);
        }

        
        return response()->json([
            'success' => true,
            'message' => 'تم التحقق من الرابط بنجاح! جاري إرساله للمعالجة بالذكاء الاصطناعي.',
            'url' => $url,
            'type' => $request->type,
            'extracted_text' => $textContent // لإغراض التصحيح فقط (يمكنك حذفه لاحقًا)
        ], 200);
    }


    /**
     * استخراج نص من الرابط (يدعم YouTube والمواقع الرياضية)
     */
    protected function extractTextFromUrl(string $url): ?string
    {
        $host = parse_url($url, PHP_URL_HOST);
        if (!$host) return null;

        $host = strtolower($host);

        // دعم YouTube
        if (Str::contains($host, ['youtube.com', 'youtu.be'])) {
            return $this->extractFromYouTube($url);
        }
         // دعم المواقع الرياضية
         $sportsDomains = [
            'kooora.com',
            'yallakora.com',
            'beinsports.com',
            'filgoal.com',
            'sport360.com'
        ];

        foreach ($sportsDomains as $domain) {
            if (Str::contains($host, $domain)) {
                return $this->extractFromSportsWebsite($url);
            }
        }

        return null;
    }

    /**
     * استخراج من YouTube
     */
    protected function extractFromYouTube(string $url): ?string
    {
        $videoId = $this->getYouTubeVideoId($url);
        if (!$videoId) return null;

        // محاولة استخدام YouTube API (إذا وُجد مفتاح)
        if ($apiKey = env('YOUTUBE_API_KEY')) {
            $response = Http::get("https://www.googleapis.com/youtube/v3/videos", [
                'id' => $videoId,
                'key' => $apiKey,
                'part' => 'snippet',
            ]);

            if ($response->successful() && !empty($response['items'])) {
                $snippet = $response['items'][0]['snippet'];
                return trim($snippet['title'] . ' ' . ($snippet['description'] ?? ''));
            }
        }
        // fallback: oEmbed
        $oembed = Http::get("https://www.youtube.com/oembed", [
            'url' => $url,
            'format' => 'json'
        ]);

        if ($oembed->successful()) {
            return $oembed['title'] ?? null;
        }

        return null;
    }

    /**
     * استخراج من المواقع الرياضية
     */
    protected function extractFromSportsWebsite(string $url): ?string
    {
        try {
            // User-Agent واقعي (Chrome على ويندوز) — مضمون ولا يُرفض
            $userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36';

            $response = Http::withHeaders([
                'User-Agent' => $userAgent,
            ])->timeout(10)->get($url);

            if (!$response->successful()) {
                return null;
            }

            $html = $response->body();
            $doc = new DOMDocument();
            libxml_use_internal_errors(true);
            $doc->loadHTML('<?xml encoding="UTF-8">' . $html, LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);
            libxml_clear_errors();
            // استخراج <title>
            $title = '';
            $titleTags = $doc->getElementsByTagName('title');
            if ($titleTags->length > 0) {
                $title = trim($titleTags->item(0)->textContent);
            }

            // استخراج وصف Meta
            $description = '';
            $metas = $doc->getElementsByTagName('meta');
            foreach ($metas as $meta) {
                if (strtolower($meta->getAttribute('name')) === 'description') {
                    $description = trim($meta->getAttribute('content'));
                    break;
                }
            }

            return $title . ' ' . $description;

        } catch (\Exception $e) {
            Log::warning("فشل استخراج نص من: $url - " . $e->getMessage());
            return null;
        }
    }

    /**
     * استخراج ID الفيديو من رابط YouTube
     */
    protected function getYouTubeVideoId(string $url): ?string
    {
        $pattern = '%(?:youtube(?:-nocookie)?\.com/(?:[^/]+/.+/|(?:v|e(?:mbed)?)/|.*[?&]v=)|youtu\.be/)([^"&?/ ]{11})%i';
        if (preg_match($pattern, $url, $matches)) {
            return $matches[1];
        }
        return null;
    }

    protected function isFootballRelated(string $text): bool
    {
        $textLower = strtolower($text);
        $score = 0;

        foreach ($this->footballKeywords as $keyword) {
            if (str_contains($textLower, strtolower($keyword))) {
                $score++;
            }
        }

        // إذا وُجدت كلمتان أو أكثر → نعتبره مرتبطًا
        return $score >= 2;
    }




    
}
