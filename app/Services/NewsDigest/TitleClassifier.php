<?php

namespace App\Services\NewsDigest;

class TitleClassifier
{
    protected array $rules = [
        'match' => ['مباراة', 'موعد', 'ضد'],
        'transfers' => ['ينتقل', 'انتقال', 'ميركاتو'],
        'players' => ['قائد', 'أراوخو', 'ليفاندوفسكي'],
        'club' => ['إدارة', 'التذاكر'],
        'quotes' => ['يفتح النار', 'هاجم', 'صرح'],
    ];

    public function classify(string $title): string
    {
        foreach ($this->rules as $topic => $keywords) {
            foreach ($keywords as $keyword) {
                if (str_contains($title, $keyword)) {
                    return $topic;
                }
            }
        }

        return 'others';
    }
}
