<?php

namespace App\Services\NewsDigest;

class DigestBuilder
{
    public function __construct(
        protected TitleClassifier $classifier
    ) {}

    public function build(array $articles): array
    {
        $digest = [
            'match' => [],
            'transfers' => [],
            'players' => [],
            'club' => [],
            'quotes' => [],
        ];

        foreach ($articles as $article) {
            $title = $article['title'] ?? null;
            if (!$title) continue;

            $topic = $this->classifier->classify($title);

            if (isset($digest[$topic])) {
                $digest[$topic][] = $title;
            }
        }

        return $digest;
    }
}
