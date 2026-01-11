<?php

namespace Tests\Feature;

use Tests\TestCase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Foundation\Testing\RefreshDatabase;
use App\Models\User;
use App\Models\Video;

class VideoControllerTest extends TestCase
{
    use RefreshDatabase;

    public function test_upload_video_success()
    {
        Storage::fake('public');

        $user = User::factory()->create([
            'username' => 'testuser', // مهم للـ DB
        ]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/videos', [
            'video' => UploadedFile::fake()->create('video.mp4', 1000, 'video/mp4'),
            'summary_type' => 'cards',
        ]);

        $response->assertStatus(200)
                 ->assertJsonStructure([
                     'success',
                     'job_id',
                     'video' => ['id', 'summary_type', 'processing_status', 'duration_seconds'],
                     'clips_dir' => ['relative', 'absolute'],
                 ]);

        $this->assertDatabaseHas('videos', [
            'user_id' => $user->id,
            'summary_type' => 'cards',
        ]);
    }

    public function test_upload_video_invalid_file()
    {
        Storage::fake('public');

        $user = User::factory()->create([
            'username' => 'testuser2',
        ]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/videos', [
            'video' => UploadedFile::fake()->create('file.svg', 100),
            'summary_type' => 'cards',
        ]);

        $response->assertStatus(422); // Validation error
        $response->assertJsonValidationErrors('video');
    }
}
