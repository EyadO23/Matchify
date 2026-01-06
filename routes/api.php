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

// // NEWS //
// //Route::get('/team-news', [TeamNewsController::class, 'show']);
// //Route::post('/team-news/summarize', [TeamNewsController::class, 'summarize']);

// Route::post('/team-news', [TeamNewsController::class, 'summarize']);
// //Route::post('/team-digest', [TeamNewsController::class, 'digest']);

// //// FavoriteTeam    //////
// Route::middleware('auth:sanctum')->group(function () {
//     Route::get('/favorite-team', [FavoriteTeamController::class, 'show']);
//     Route::post('/favorite-team', [FavoriteTeamController::class, 'store']);
//     Route::put('/favorite-team', [FavoriteTeamController::class, 'store']);
// });





//////// favorite team & news ///////////////
Route::middleware('auth:sanctum')->group(function () {
    
    // 🔹 إدارة الفرق المفضلة
    Route::prefix('favorite-teams')->group(function () {
        Route::get('/', [FavoriteTeamController::class, 'index']);
        Route::post('/', [FavoriteTeamController::class, 'store']);
        Route::put('/reset', [FavoriteTeamController::class, 'updateMultiple']);
        Route::delete('/{teamId}', [FavoriteTeamController::class, 'destroy']);
        Route::get('/available', [FavoriteTeamController::class, 'availableTeams']);
        Route::post('/favorite-teams/multiple', [FavoriteTeamController::class, 'storeMultiple']);
    });
    
    // 🔹 أخبار الفرق
    Route::post('/teams/news', [TeamNewsController::class, 'getTeamNews']);
    
    // أو GET
    Route::get('/teams/{teamId}/news', [TeamNewsController::class, 'getTeamNews']);
    
    Route::get('/team-news/favorites', [TeamNewsController::class, 'getFavoriteTeamsNews']);
});



use App\Http\Controllers\VideoController;
use App\Http\Controllers\SummaryController;

// ===================
// Video Endpoints
// ===================

// رفع فيديو جديد
Route::post('/videos', [VideoController::class, 'store']);

// متابعة تقدم الفيديو
Route::get('/videos/{job_id}/progress', [VideoController::class, 'progress']);

// جلب تقرير الفيديو النهائي
Route::get('/videos/{video_id}/report', [VideoController::class, 'report']);

Route::get('/clean-old-videos', [VideoController::class, 'cleanOldVideos']);

// ===================
// Video Summary Endpoints
// ===================

// إنشاء ملخص للفيديو
Route::post('/video_summaries/generate', [SummaryController::class, 'generate']);

// متابعة تقدم الملخص + نتيجة المعالجة
Route::get('/video_summaries/{jobId}/result', [SummaryController::class, 'result']);




Route::post('/send-test-notification', [NotificationController::class, 'sendTest']);