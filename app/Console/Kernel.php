<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    /**
     * Register any application commands.
     */
    protected function commands()
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }

    /**
     * Define the application's command schedule.
     */
    protected function schedule(Schedule $schedule)
    {
        // هنا نضيف الجدولة
        // مثال (يعمل كل ساعة):
        // $schedule->call(function () {})->hourly();
    }
    protected $routeMiddleware= [
        'admin' => \App\Http\Middleware\AdminMiddleware::class,
    ];
}
