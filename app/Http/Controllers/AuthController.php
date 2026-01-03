<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Laravel\Socialite\Facades\Socialite;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Facades\Mail;
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
            'role' => 'sometimes|in:user,admin'
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
            'role' => $validated['role'] ?? 'user'
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'تم التسجيل بنجاح',
            'user' => $user,
            'token' => $token
        ]);
    }

   public function forgotPassword(Request $request)
{
    $request->validate([
        'username' => 'required|string',
        'email' => 'required|email',
    ]);

    // جلب المستخدم باليوزرنيم
    $user = User::where('username', $request->username)->first();

    if (!$user) {
        return response()->json([
            'success' => false,
            'message' => 'اسم المستخدم غير صحيح'
        ], 404);
    }

    // التحقق أن الإيميل يخص هذا المستخدم
    if ($user->email !== $request->email) {
        return response()->json([
            'success' => false,
            'message' => 'الإيميل لا يطابق هذا المستخدم'
        ], 403);
    }

    // إرسال رابط إعادة التعيين
    $status = Password::sendResetLink([
        'email' => $user->email
    ]);

    return $status === Password::RESET_LINK_SENT
        ? response()->json([
            'success' => true,
            'message' => 'تم إرسال رابط إعادة تعيين كلمة المرور'
        ])
        : response()->json([
            'success' => false,
            'message' => 'حدث خطأ أثناء الإرسال'
        ], 500);
}



public function resetPassword(Request $request)
{
    $request->validate([
        'email' => 'required|email',
        'token' => 'required',
        'password' => 'required|min:8|confirmed',
    ]);

    $status = Password::reset(
        $request->only('email', 'password', 'password_confirmation', 'token'),
        function ($user, $password) {
            $user->password = Hash::make($password);
            $user->save();

            // تسجيل خروج من كل الأجهزة
            $user->tokens()->delete();
        }
    );

    return $status === Password::PASSWORD_RESET
        ? response()->json([
            'success' => true,
            'message' => 'تم تغيير كلمة المرور بنجاح'
        ])
        : response()->json([
            'success' => false,
            'message' => 'الرابط غير صالح أو منتهي'
        ], 400);
}

    // تغيير كلمة المرور
    public function changePassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'current_password' => 'required|string',
            'new_password' => 'required|string|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'البيانات غير صحيحة',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = $request->user();

        // التحقق من كلمة المرور الحالية
        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'كلمة المرور الحالية غير صحيحة'
            ], 401);
        }

        // تحديث كلمة المرور
        $user->password = Hash::make($request->new_password);
        $user->save();

        // حذف جميع التوكنات (اختياري – للأمان)
        $user->tokens()->delete();

        return response()->json([
            'success' => true,
            'message' => 'تم تغيير كلمة المرور بنجاح، يرجى تسجيل الدخول مرة أخرى'
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