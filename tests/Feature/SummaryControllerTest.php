<?php

namespace Tests\Feature;

use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use App\Models\User;
use App\Models\Video;

class SummaryControllerTest extends TestCase
{
    use RefreshDatabase;

    public function test_generate_summary_success()
    {
        $user = User::factory()->create([
            'username' => 'testuser',
        ]);

        $video = Video::factory()->create([
            'user_id' => $user->id, // اربط الفيديو بالمستخدم
            'summary_type' => 'cards',
        ]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/video_summaries/generate', [
            'clips_dir' => 'storage/app/public/video_ai/clips/job_'.$video->id,
            'video_id' => $video->id,
        ]);

        $response->assertStatus(200)
                 ->assertJson([
                     'success' => true,
                     'job_id' => (string) $video->id,
                 ]);
    }

    public function test_generate_summary_invalid_video()
    {
        $user = User::factory()->create([
            'username' => 'testuser2',
        ]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/video_summaries/generate', [
            'clips_dir' => 'storage/app/public/video_ai/clips/job_999',
            'video_id' => 999, // فيديو غير موجود
        ]);

        $response->assertStatus(422);
        $response->assertJsonValidationErrors('video_id');
    }
}
