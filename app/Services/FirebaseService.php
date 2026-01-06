<?php

namespace App\Services;

use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class FirebaseService
{
    protected $messaging;

    public function __construct()
    {
        // تهيئة Firebase
        $factory = (new Factory)
            ->withServiceAccount(storage_path('app/Firebase/serviceAccountKey.json')); // مسار ملف JSON
        $this->messaging = $factory->createMessaging();
    }

    /**
     * إرسال إشعار لجهاز واحد
     */
    public function sendNotificationToDevice(string $deviceToken, string $title, string $body)
    {
        $notification = Notification::create($title, $body);

        $message = CloudMessage::new()
            ->withNotification($notification)
            ->toToken($deviceToken); // ← استخدمنا toToken بدل withTarget

        try {
            $this->messaging->send($message);
            return ['success' => true, 'message' => 'تم إرسال الإشعار بنجاح!'];
        } catch (\Kreait\Firebase\Exception\MessagingException $e) {
            return ['success' => false, 'error' => $e->getMessage()];
        } catch (\Kreait\Firebase\Exception\FirebaseException $e) {
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    /**
     * إرسال إشعارات لعدة أجهزة (Multicast)
     */
    public function sendNotificationToDevices(array $deviceTokens, string $title, string $body)
    {
        $notification = Notification::create($title, $body);

        $message = CloudMessage::new()
            ->withNotification($notification);

        $report = $this->messaging->sendMulticast($message, $deviceTokens);

        return [
            'success_count' => $report->successes()->count(),
            'failure_count' => $report->failures()->count(),
        ];
    }
}
