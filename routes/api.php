<?php



use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Filttercontroller;

use App\Http\Controllers\AuthController;
use Illuminate\Http\Request;
use App\Http\Controllers\FirebaseAuthController;

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
Route::post('/filters', [Filttercontroller::class, 'store']);



//--------------Auth------------//
Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);
Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
Route::middleware('auth:sanctum')->post('/logout', [AuthController::class, 'logout']);

//Route::get('/auth/google/redirect', [AuthController::class, 'redirectToGoogle']);
//Route::get('/auth/google/callback', [AuthController::class, 'handleGoogleCallback']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/me', function (Request $request) {
        return $request->user();
    });
});

Route::post('/auth/firebase', [FirebaseAuthController::class, 'login']);