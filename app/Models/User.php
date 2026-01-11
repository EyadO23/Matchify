<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use App\Http\Controllers\AuthController;
use Illuminate\Database\Eloquent\Relations\HasMany;
use App\Notifications\CustomResetPassword;
use Illuminate\Auth\Notifications\ResetPassword as BaseResetPassword;


class User extends Authenticatable implements MustVerifyEmail
{
    use HasApiTokens, Notifiable,  HasFactory; // 

    


//class User extends Authenticatable
//{
    /** @use HasFactory<\Database\Factories\UserFactory> */
  //  use HasFactory, Notifiable,HasApiTokens;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    
    protected $fillable = [
        'name',
        'username',
        'email',
        'password',
        'role',
        'fcm_token'
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    public function isAdmin()
    {
        return $this->role === 'admin';
    }

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function sendPasswordResetNotification($token)
    {
        $this->notify(new CustomResetPassword($token));
    }



    public function videos()
    {
        return $this->hasMany(Video::class);
    }

    
    public function favoriteTeams()
    {
        return $this->belongsToMany(
            Team::class,           // النموذج المرتبط
            'favorite_teams',      // اسم جدول الكسر
            'user_id',             // المفتاح الخارجي للـ User
            'team_id',             // المفتاح الخارجي للـ Team
            'id',                  // المفتاح الأساسي للـ User
            'team_id'                   // المفتاح الأساسي للـ Team
        )->withTimestamps();
    }


}
