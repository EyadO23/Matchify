<?php

namespace Tests\Feature;

use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthControllerTest extends TestCase
{
    use RefreshDatabase;

    public function test_register_success()
    {
        $response = $this->postJson('/api/register', [
            'name' => 'John Doe',
            'username' => 'johndoe',
            'email' => 'johndoe@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertStatus(200)
                 ->assertJson(['success' => true]);

        $this->assertDatabaseHas('users', [
            'username' => 'johndoe',
            'email' => 'johndoe@example.com',
        ]);
    }

    public function test_login_success()
    {
        $user = User::factory()->create([
            'username' => 'johndoe',
            'password' => Hash::make('password123'),
        ]);

        $response = $this->postJson('/api/login', [
            'username' => 'johndoe',
            'password' => 'password123',
        ]);

        $response->assertStatus(200)
                 ->assertJson(['success' => true]);

        $this->assertArrayHasKey('token', $response->json());
    }

    public function test_login_wrong_credentials()
    {
        $user = User::factory()->create([
            'username' => 'johndoe',
            'password' => Hash::make('password123'),
        ]);

        $response = $this->postJson('/api/login', [
            'username' => 'johndoe',
            'password' => 'wrongpassword',
        ]);

        $response->assertStatus(401)
                 ->assertJson(['success' => false]);
    }

    public function test_change_password_success()
    {
        $user = User::factory()->create([
            'password' => Hash::make('oldpassword'),
        ]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/change-password', [
            'current_password' => 'oldpassword',
            'new_password' => 'newpassword123',
            'new_password_confirmation' => 'newpassword123',
        ]);

        $response->assertStatus(200)
                 ->assertJson(['success' => true]);

        $this->assertTrue(Hash::check('newpassword123', $user->fresh()->password));
    }

    public function test_change_password_wrong_current()
    {
        $user = User::factory()->create([
            'password' => Hash::make('oldpassword'),
        ]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/change-password', [
            'current_password' => 'wrongpassword',
            'new_password' => 'newpassword123',
            'new_password_confirmation' => 'newpassword123',
        ]);

        $response->assertStatus(401)
                 ->assertJson(['success' => false]);
    }

    public function test_logout_success()
    {
        $user = User::factory()->create();

        $token = $user->createToken('auth_token')->plainTextToken;

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->postJson('/api/logout');

        $response->assertStatus(200)
                 ->assertJson(['success' => true]);
    }
}
