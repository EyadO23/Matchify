<?php



use Illuminate\Support\Facades\Route;
use App\Http\Controllers\FiltterController;

use App\Http\Controllers\AuthController;
use Illuminate\Http\Request;
use App\Http\Controllers\FirebaseAuthController;
use App\Http\Controllers\Api\TeamNewsController;
use App\Http\Controllers\Api\FavoriteTeamController;
use App\Http\Controllers\GoalDetectionController;



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

    return $user->createToken($request->device_name)->plainTextToken;
});

//------------Filtter---------//
/*Route::middleware('auth:api')->group(function () {
Route::post('/filters', [Filttercontroller::class, 'store']);

});*/
//Route::post('/filters', [Filttercontroller::class, 'store'])->middleware('auth:sanctum');
// Route::post('/filtter', [Filttercontroller::class, 'store'])
//     ->middleware('auth:sanctum');
Route::get('/video-result/{jobId}', [FiltterController::class, 'getResult']);
Route::middleware('auth:sanctum')->group(function() {
    Route::post('/filter', [FiltterController::class, 'store']);
    Route::get('/filter/result/{jobId}', [FiltterController::class, 'getResult']);
    });
    Route::middleware(['auth:sanctum', 'admin'])->group(function () {
    Route::get('/admin/filtter/jobs', [FiltterController::class, 'getAllJobs']);
});

//--------------Auth------------//
Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);
Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
Route::post('/reset-password', [AuthController::class, 'resetPassword']);
Route::middleware('auth:sanctum')->post('/change-password', [AuthController::class, 'changePassword']);
Route::middleware('auth:sanctum')->post('/logout', [AuthController::class, 'logout']);
////// Admin ///////
Route::middleware(['auth:sanctum', 'admin'])->group(function () {

    Route::get('/admin/dashboard', function () {
        return response()->json([
            'success' => true,
            'message' => 'مرحبا بك أيها الأدمن '
        ]);
    });

});


//Route::get('/auth/google/redirect', [AuthController::class, 'redirectToGoogle']);
//Route::get('/auth/google/callback', [AuthController::class, 'handleGoogleCallback']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/me', function (Request $request) {
        return $request->user();
    });
});

Route::post('/auth/firebase', [FirebaseAuthController::class, 'login']);

// NEWS //
//Route::get('/team-news', [TeamNewsController::class, 'show']);
//Route::post('/team-news/summarize', [TeamNewsController::class, 'summarize']);

Route::post('/team-news', [TeamNewsController::class, 'summarize']);
//Route::post('/team-digest', [TeamNewsController::class, 'digest']);

//// FavoriteTeam    //////
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/favorite-team', [FavoriteTeamController::class, 'show']);
    Route::post('/favorite-team', [FavoriteTeamController::class, 'store']);
    Route::put('/favorite-team', [FavoriteTeamController::class, 'store']);
});


use App\Http\Controllers\HighlightController;


Route::prefix('highlights')->middleware('auth')->group(function () {
    // إنشاء Job جديد
    Route::post('/generate', [HighlightController::class, 'generate']);

    // جلب حالة / نتيجة Job
    Route::get('/result/{jobId}', [HighlightController::class, 'result']);
});