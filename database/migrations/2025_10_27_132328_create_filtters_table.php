<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('filtters', function (Blueprint $table) {
            $table->id();
            $table->string('url');
            $table->enum('filter_type', ['اهداف', 'بطاقة حمراء', 'لقطات لاعب معين']);
            $table->string('player_name')->nullable();
            $table->enum('summary_type', ['قصير', 'طويل']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('filtters');
    }
};
