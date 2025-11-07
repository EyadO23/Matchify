<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Laravel\Socialite\Facades\Socialite;

class AuthController extends Controller
{
    // تسجيل الدخول
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'username' => 'required|string',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'البيانات غير صحيحة',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = User::where('username', $request->username)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'اسم المستخدم أو كلمة المرور غير صحيحة'
            ], 401);
        }

        // إنشاء توكن
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'تم تسجيل الدخول بنجاح',
            'user' => $user,
            'token' => $token
        ]);
    }

    // تسجيل مستخدم جديد
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'username' => 'required|string|unique:users,username|max:255',
            'email' => 'required|string|email|unique:users,email',
            'password' => 'required|string|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'فشل التسجيل',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = User::create([
            'name' => $request->name,
            'username' => $request->username,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'تم التسجيل بنجاح',
            'user' => $user,
            'token' => $token
        ]);
    }

    // إعادة تعيين كلمة المرور (نسيت كلمة المرور)
    public function forgotPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'يرجى إدخال بريد إلكتروني صحيح',
                'errors' => $validator->errors()
            ], 422);
        }

        // هنا يمكنك إرسال رابط إعادة تعيين كلمة المرور عبر البريد (نستخدم بسيطة للتجربة)
        // في التطبيق الحقيقي: استخدم Mail facade + Password Reset

        return response()->json([
            'success' => true,
            'message' => 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني'
        ]);
    }

    // تسجيل الخروج
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json([
            'success' => true,
            'message' => 'تم تسجيل الخروج بنجاح'
        ]);
    }

    
    public function redirectToGoogle()
    {
         return Socialite::driver('google')->redirect();
    }

    public function handleGoogleCallback()
    {
        try {
            $user = Socialite::driver('google')->user();
        
            $findUser = User::where('email', $user->getEmail())->first();

        if ($findUser) {
            Auth::login($findUser);
        } else {
            $newUser = User::create([
                'name' => $user->getName(),
                'username' => str_replace(' ', '_', strtolower($user->getName())),
                'email' => $user->getEmail(),
                'password' => Hash::make(rand(100000, 999999))
            ]);

            Auth::login($newUser);
        }

            $token = $findUser ? $findUser : $newUser;
            $token = $token->createToken('auth_token')->plainTextToken;

            return response()->json([
            'success' => true,
            'message' => 'تم تسجيل الدخول عبر Google',
            'user' => $token,
            'token' => $token
        ]);

        } catch (\Exception $e) {
               return response()->json([
                'success' => false,
                'message' => 'حدث خطأ أثناء تسجيل الدخول عبر Google'
                ], 500);
        }
    }

    
}