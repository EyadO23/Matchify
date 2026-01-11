<?php




namespace App\Services;

use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;
use Illuminate\Support\Facades\Log;

class FirebaseService
{
    protected $messaging;

    public function __construct()
    {
        // تهيئة Firebase
        $factory = (new Factory)
            ->withServiceAccount(storage_path('app/Firebase/serviceAccountKey.json'));

        $this->messaging = $factory->createMessaging();
    }

    /**
     * إرسال إشعار لجهاز واحد
     */
    public function sendNotificationToDevice(string $deviceToken, string $title, string $body)
    {
        try {
            $notification = Notification::create($title, $body);

            $message = CloudMessage::new()
                ->withNotification($notification)
                ->toToken($deviceToken);

            $sendResult = $this->messaging->send($message);

            Log::info('Firebase Notification sent', [
                'token' => $deviceToken,
                'title' => $title,
                'body' => $body,
                'firebase_result' => $sendResult,
            ]);

            return [
                'success' => true,
                'message' => 'تم إرسال الإشعار بنجاح!',
                'firebase_result' => $sendResult,
            ];

        } catch (\Throwable $e) {
            Log::error('Firebase Notification error', [
                'token' => $deviceToken,
                'error' => $e->getMessage(),
            ]);

            return [
                'success' => false,
                'error' => $e->getMessage(),
            ];
        }
    }

    /**
     * إرسال إشعار لعدة أجهزة (Multicast)
     */
    public function sendNotificationToDevices(array $deviceTokens, string $title, string $body)
    {
        try {
            $notification = Notification::create($title, $body);

            $message = CloudMessage::new()
                ->withNotification($notification);

            $report = $this->messaging->sendMulticast($message, $deviceTokens);

            $failures = [];
            foreach ($report->failures() as $item) {
                if (method_exists($item, 'error') && $item->error() !== null) {
                    $failures[] = $item->error()->getMessage();
                } else {
                    $failures[] = 'Unknown error';
                }
            }

            Log::info('Firebase Multicast Notification sent', [
                'tokens_count' => count($deviceTokens),
                'success_count' => $report->successes()->count(),
                'failure_count' => $report->failures()->count(),
                'failures' => $failures,
            ]);

            return [
                'success_count' => $report->successes()->count(),
                'failure_count' => $report->failures()->count(),
                'failures' => $failures,
            ];

        } catch (\Throwable $e) {
            Log::error('Firebase Multicast error', [
                'tokens' => $deviceTokens,
                'error' => $e->getMessage(),
            ]);

            return [
                'success_count' => 0,
                'failure_count' => count($deviceTokens),
                'error' => $e->getMessage(),
            ];
        }
    }
}
