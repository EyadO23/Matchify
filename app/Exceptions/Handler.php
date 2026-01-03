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
        if ($request->wantsJson() || $request->is('api/*')) {
            if ($e instanceof AuthenticationException) {
                return response()->json([
                    'success' => false,
                    'message' => 'يجب تسجيل الدخول أولاً (Token غير صالح أو مفقود).'
                ], 401);
            }

            if ($e instanceof ValidationException) {
                return response()->json([
                    'success' => false,
                    'message' => 'بيانات غير صالحة',
                    'errors' => $e->errors()
                ], 422);
            }

            // لأي خطأ داخلي: لا تُظهر التفاصيل في الإنتاج
            return response()->json([
                'success' => false,
                'message' => 'حدث خطأ داخلي. يُرجى المحاولة لاحقًا.'
            ], 500);
        }

        return parent::render($request, $e);
    }
}