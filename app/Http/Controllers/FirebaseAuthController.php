<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Exception\Auth\InvalidIdToken;
use App\Models\User;

class FirebaseAuthController extends Controller
{
    public function login(Request $request)
    {

         if (app()->environment('local') && $request->id_token === 'test_firebase_token') {
        $user = User::firstOrCreate(
            ['email' => 'test@example.com'],
            [
                'name' => 'Test User',
                'username' => 'test_user_' . Str::random(6),
                'password' => Hash::make(Str::random(32)),
                'email_verified_at' => now(),
            ]
        );

        $token = $user->createToken('test')->plainTextToken;
        return response()->json([
            'success' => true,
            'user' => $user,
            'token' => $token
        ]);
    }
    //
        $request->validate([
            'id_token' => 'required|string',
        ]);

        try {
            // إنشاء عميل Firebase
            $firebase = (new Factory)
                ->withServiceAccount(storage_path('app/firebase/serviceAccountKey.json'))
                ->createAuth();

            // التحقق من صحة الـ ID Token
            $verifiedIdToken = $firebase->verifyIdToken($request->id_token);

            $uid = $verifiedIdToken->claims()->get('sub'); // Unique Firebase UID
            $email = $verifiedIdToken->claims()->get('email');
            $name = $verifiedIdToken->claims()->get('name') ?? 'Unknown';
            $picture = $verifiedIdToken->claims()->get('picture') ?? null;

            if (!$email) {
                return response()->json([
                    'success' => false,
                    'message' => 'البريد الإلكتروني مطلوب.'
                ], 400);
            }

            // البحث عن المستخدم أو إنشاؤه
           $user = User::firstOrCreate(
    ['email' => $email],
    [
        'name' => $name,
        'username' => $this->generateUsername($email), // ← أضف هذا
        'password' => Hash::make(Str::random(32)),
        'email_verified_at' => now(),
    ]
);

            // إنشاء Token لاستخدامه مع Sanctum
            $token = $user->createToken('firebase-login')->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'تم تسجيل الدخول بنجاح',
                'user' => $user,
                'token' => $token
            ]);

        } catch (InvalidIdToken $e) {
            return response()->json([
                'success' => false,
                'message' => 'الرمز غير صالح أو منتهي الصلاحية.'
            ], 401);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'حدث خطأ أثناء التحقق من الهوية.'
            ], 500);
        }
    }

    private function generateUsername($email)
{
    $base = explode('@', $email)[0];
    $username = $base;
    $counter = 1;

    while (User::where('username', $username)->exists()) {
        $username = $base . '_' . $counter;
        $counter++;
    }

    return $username;
}
}
