package com.example.flutterplatformmusic

import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.MediaPlayer
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class MyService : Service() {

    lateinit var player:MediaPlayer

    override fun onCreate() {
        super.onCreate()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val builder: NotificationCompat.Builder =
                    NotificationCompat.Builder(this, "messages")
                            .setContentText("Background Service")
                            .setContentTitle("Flutter Background Services")
            startForeground(101, builder.build())
        }
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        player = MediaPlayer.create(this, R.raw.sample)
        player.isLooping = true
        player.start()
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        player.stop()
    }

    fun stopService(context: Context) {
        val stopIntent = Intent(context, MyService::class.java)
        context.stopService(stopIntent)
    }
}