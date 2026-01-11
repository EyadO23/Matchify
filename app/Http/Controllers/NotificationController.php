<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\FirebaseService;

class NotificationController extends Controller
{
    public function __construct(protected FirebaseService $firebase)
    {
    }

    /**
     * حفظ FCM token للمستخدم الحالي
     */
    public function saveFcmToken(Request $request)
    {
        $request->validate([
            'fcm_token' => 'required|string',
        ]);

        $user = $request->user();
        $user->update([
            'fcm_token' => $request->fcm_token,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'FCM token saved successfully'
        ]);
    }

    /**
     * إرسال إشعار تجريبي للمستخدم الحالي
     */
    public function sendTestNotification(Request $request)
    {
        $request->validate([
            'fcm_token' => 'required|string',
        ]);

        $result = $this->firebase->sendNotificationToDevice(
            $request->fcm_token,
            "Test Notification",
            "This is a test notification from Laravel."
        );

        return response()->json($result);
    }
}
