<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class BlockedUserMiddleware
{
    public function handle(Request $request, Closure $next)
    {
        $user = $request->user();

        if ($user && $user->role === 'blocked') {
            return response()->json([
                'success' => false,
                'message' => 'تم حظرك من النظام'
            ], 403);
        }

        return $next($request);
    }
}
