<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use App\Models\Video;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
class VideoFactory extends Factory
{
    protected $model = Video::class;

    public function definition(): array
    {
        return [
            'user_id' => User::factory(), // ينشئ مستخدم تلقائيًا إذا لم يمرر
            'summary_type' => $this->faker->randomElement(['cards', 'goals']),
            'processing_status' => 'uploaded',
            'duration_seconds' => $this->faker->numberBetween(10, 300),
        ];
    }
}
