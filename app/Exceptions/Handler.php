<?php

namespace App\Exceptions;

use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Throwable;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Validation\ValidationException;

class Handler extends ExceptionHandler
{
    public function render($request, Throwable $e)
    {
        if ($request->is('api/*')) {

            if ($e instanceof AuthenticationException) {
                return response()->json([
                    'success' => false,
                    'message' => 'Token غير صالح أو منتهي. يرجى تسجيل الدخول.'
                ], 401);
            }

            if ($e instanceof ValidationException) {
                return response()->json([
                    'success' => false,
                    'message' => 'بيانات غير صالحة',
                    'errors' => $e->errors()
                ], 422);
            }

            return response()->json([
                'success' => false,
                'message' => 'حدث خطأ داخلي. يُرجى المحاولة لاحقًا.'
            ], 500);
        }

        return parent::render($request, $e);
    }

    
protected function unauthenticated($request, AuthenticationException $exception)
{
    if ($request->expectsJson()) {
        return response()->json([
            'success' => false,
            'message' => 'Unauthenticated'
        ], 401);
    }

    return redirect()->guest(route('login'));
}
}
