<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\FiltterController;
use App\Http\Controllers\AuthController;
use Illuminate\Http\Request;
use App\Http\Controllers\FirebaseAuthController;
use App\Http\Controllers\Api\TeamNewsController;
use App\Http\Controllers\Api\FavoriteTeamController;
use App\Http\Controllers\GoalDetectionController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\Admin\UserController as AdminUserController;
use App\Http\Controllers\VideoController;
use App\Http\Controllers\SummaryController;

/*
|--------------------------------------------------------------------------
| Sanctum Token
|--------------------------------------------------------------------------
*/
Route::post('/sanctum/token', function (Request $request) {
    $request->validate([
        'email' => 'required|email',
        'password' => 'required',
        'device_name' => 'required',
    ]);

    $user = \App\Models\User::where('email', $request->email)->first();

    if (! $user || ! \Hash::check($request->password, $user->password)) {
        return response()->json(['message' => 'Invalid credentials'], 401);
    }

    return $user->createToken(
        $request->device_name,
        ['*'],
        now()->addWeek()
    )->plainTextToken;
});

/*
|--------------------------------------------------------------------------
| Auth
|--------------------------------------------------------------------------
*/
Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);
Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
Route::post('/reset-password', [AuthController::class, 'resetPassword']);

Route::middleware(['auth:sanctum', 'token.expired'])
    ->post('/change-password', [AuthController::class, 'changePassword']);

Route::middleware(['auth:sanctum', 'token.expired'])
    ->post('/logout', [AuthController::class, 'logout']);

/*
|--------------------------------------------------------------------------
| Admin
|--------------------------------------------------------------------------
*/
Route::middleware(['auth:sanctum', 'token.expired', 'admin'])
    ->prefix('admin')
    ->group(function () {

        Route::get('/dashboard', function () {
            return response()->json([
                'success' => true,
                'message' => 'مرحبا بك أيها الأدمن'
            ]);
        });

        Route::get('/users', [AdminUserController::class, 'index']);
        Route::put('/users/{id}', [AdminUserController::class, 'block']);
        Route::put('/users/{id}/unblock', [AdminUserController::class, 'unblock']);
        Route::get('/users/blocked', [AdminUserController::class, 'blockedUsers']);
        Route::get('/users/{id}/video-reports', [AdminUserController::class, 'SummaryReports']);
    });

/*
|--------------------------------------------------------------------------
| User (مع blocked)
|--------------------------------------------------------------------------
*/
Route::middleware(['auth:sanctum', 'token.expired', 'blocked'])->group(function () {

    Route::get('/me', function (Request $request) {
        return $request->user();
    });

    /*
    |--------------------------------------------------------------------------
    | Favorite Teams & News
    |--------------------------------------------------------------------------
    */
    Route::get('/favorite-teams', [FavoriteTeamController::class, 'index']);
    Route::post('/favorite-teams', [FavoriteTeamController::class, 'store']);
    Route::put('/favorite-teams/reset', [FavoriteTeamController::class, 'updateMultiple']);
    Route::delete('/favorite-teams/{teamId}', [FavoriteTeamController::class, 'destroy']);
    Route::get('/favorite-teams/available', [FavoriteTeamController::class, 'availableTeams']);
    Route::post('/favorite-teams/favorite-teams/multiple', [FavoriteTeamController::class, 'storeMultiple']);

    Route::post('/teams/news', [TeamNewsController::class, 'getTeamNews']);
    Route::get('/teams/{teamId}/news', [TeamNewsController::class, 'getTeamNews']);
    Route::get('/team-news/favorites', [TeamNewsController::class, 'getFavoriteTeamsNews']);

    /*
    |--------------------------------------------------------------------------
    | Videos
    |--------------------------------------------------------------------------
    */
    Route::post('/videos', [VideoController::class, 'store']);
    Route::get('/videos/{job_id}/progress', [VideoController::class, 'progress']);
    Route::get('/videos/{video_id}/report', [VideoController::class, 'report']);

    Route::get('/clean-old-videos', [SummaryController::class, 'cleanupAfterProcessing']);

    /*
    |--------------------------------------------------------------------------
    | Summaries
    |--------------------------------------------------------------------------
    */
    Route::post('/video_summaries/generate', [SummaryController::class, 'generate']);
    Route::get('/video_summaries/{jobId}/result', [SummaryController::class, 'result']);
    Route::get('/my/highlights', [SummaryController::class, 'myHighlights']);

    /*
    |--------------------------------------------------------------------------
    | Notifications
    |--------------------------------------------------------------------------
    */
    Route::post('/save-fcm-token', [NotificationController::class, 'saveFcmToken']);
    Route::post('/send-test-notification', [NotificationController::class, 'sendTestNotification']);
});

/*
|--------------------------------------------------------------------------
| Firebase
|--------------------------------------------------------------------------
*/
Route::post('/auth/firebase', [FirebaseAuthController::class, 'login']);

/*
|--------------------------------------------------------------------------
| Admin Video Reports
|--------------------------------------------------------------------------
*/
Route::middleware(['auth:sanctum', 'admin'])->get(
    '/videos/reportAll',
    [VideoController::class, 'reportAll']
);
