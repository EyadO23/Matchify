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
        Schema::create('highlights', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id')->nullable(); // ممكن يكون null
            $table->string('job_id')->unique();
            $table->string('clips_dir');                      // مسار الكليبات الأصلية
            $table->string('summary_type');                   // goals / cards
            $table->string('summary_length');                 // short / long
            $table->float('threshold')->nullable();           // عتبة الاختيار
            $table->json('result')->nullable();              // بيانات JSON
            $table->string('storage_path')->nullable(); 
            $table->string('status')->default('queued'); // في الميجريشن
     // مسار الفيديو النهائي
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('highlights');
    }
};
