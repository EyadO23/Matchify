<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Models\User;
return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('videos', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->string('url')->nullable();
            $table->enum('summary_type', ['اهداف', 'بطاقة حمراء', 'لقطات لاعب معين','بطاقة صفراء']);
            $table->enum('summary_length', ['قصير', 'طويل']);
            $table->integer('duration_seconds')->nullable();
            $table->enum('processing_status', [
                                                'uploaded',
                                                'processing',
                                                'done',
                                                'failed',
                                            ])->default('uploaded');
            $table->timestamps();
        });
    }

    /**
     * 
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('videos');
    }
};
