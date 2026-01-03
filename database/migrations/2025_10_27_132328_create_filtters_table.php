<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Models\Filtter;
use App\Models\User;
return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('filtters', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->string('url')->nullable();
            $table->enum('filter_type', ['اهداف', 'بطاقة حمراء', 'لقطات لاعب معين','بطاقة صفراء']);
            $table->string('player_name')->nullable();
            $table->enum('summary_type', ['قصير', 'طويل']);
            $table->text('extracted_text')->nullable();
            $table->timestamps();
        });
    }

    /**
     * 
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('filtters');
    }
};
