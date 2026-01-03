<?php

namespace App\Notifications;

use Illuminate\Notifications\Notification;
use Illuminate\Notifications\Messages\MailMessage;

class CustomResetPassword extends Notification
{
    public string $token;

    public function __construct(string $token)
    {
        $this->token = $token;
    }

    public function via($notifiable)
    {
        return ['mail'];
    }

    public function toMail($notifiable)
    {
        $url = config('app.frontend_url') .
            "/reset-password?token={$this->token}&email={$notifiable->email}";

        return (new MailMessage)
            ->subject('إعادة تعيين كلمة المرور - Matchify')
            ->greeting('مرحبًا 👋')
            ->line('لقد طلبت إعادة تعيين كلمة المرور الخاصة بك.')
            ->line('اضغط على الزر التالي لإعادة تعيين كلمة المرور:')
            ->action('إعادة تعيين كلمة المرور', $url)
            ->line('أو انسخ التوكن التالي والصقه في التطبيق:')
            ->line("🔐 **{$this->token}**")
            ->line('إذا لم تطلب إعادة التعيين، تجاهل هذا الإيميل.')
            ->salutation('— فريق Matchify ⚽');
    }
}
