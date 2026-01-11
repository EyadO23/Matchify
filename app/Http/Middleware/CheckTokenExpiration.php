<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Laravel\Sanctum\PersonalAccessToken; 

class CheckTokenExpiration
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next)
{
    $user = $request->user();

    if ($user) {
        $token = $user->currentAccessToken();
        if ($token && $token->expires_at && $token->expires_at->isPast()) {
            /** @var PersonalAccessToken $token */
            $token->delete();
            return response()->json([
                'success' => false,
                'message' => 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى'
            ], 401);
        }
    }

    return $next($request);
}
}
