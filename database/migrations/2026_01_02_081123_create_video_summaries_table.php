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
        Schema::create('video_summaries', function (Blueprint $table) {
            $table->id();
             $table->foreignId('video_id')
                  ->unique()             
                  ->constrained('videos')
                  ->restrictOnDelete();   // بدون cascade
            $table->string('storage_path')->nullable(); 
            $table->integer('start_time_sec'); // بداية المقطع بالثواني
            $table->integer('end_time_sec');   // نهاية المقطع بالثواني
            $table->decimal('confidence_score', 5, 4)->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('video_summaries');
    }
};
