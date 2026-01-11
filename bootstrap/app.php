<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use App\Http\Middleware\AdminMiddleware;

return Application::configure(basePath: dirname(__DIR__))

    ->withMiddleware(function (Middleware $middleware) {

        // ✅ CORS
        $middleware->web()->prepend(\App\Http\Middleware\HandleCors::class);
        $middleware->api()->prepend(\App\Http\Middleware\HandleCors::class);

        // ✅ Alias للـ middleware
        $middleware->alias([
            'admin' => AdminMiddleware::class,
            'token.expired' => \App\Http\Middleware\CheckTokenExpiration::class,
            'blocked'       => \App\Http\Middleware\BlockedUserMiddleware::class,
        ]);
    })

    ->withExceptions(function (Exceptions $exceptions) {
        //
    })

    ->create();

    
   