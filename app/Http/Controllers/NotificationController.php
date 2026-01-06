<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\FirebaseService;

class NotificationController extends Controller
{
   // protected FirebaseService $firebase;

    public function __construct(protected FirebaseService $firebase)
    {
        $this->firebase = $firebase;
    }

    public function sendTest(Request $request)
    {
        $request->validate([
            'token' => 'required|string',
            'title' => 'required|string',
            'body' => 'required|string',
        ]);

        $result = $this->firebase->sendNotificationToDevice(
            $request->token,
            $request->title,
            $request->body
        );

        return response()->json($result);
    }
}
