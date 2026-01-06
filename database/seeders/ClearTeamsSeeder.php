<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ClearTeamsSeeder extends Seeder
{
    public function run(): void
    {
        // حذف جميع الفرق
        DB::table('teams')->truncate();
        echo "✅ تم حذف جميع الفرق\n";
    }
}