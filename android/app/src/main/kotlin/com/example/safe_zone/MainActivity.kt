package com.example.safe_zone

import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "voice_service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )

        VoiceService.channel = methodChannel

        methodChannel.setMethodCallHandler { call, result ->
            val intent = Intent(this, VoiceService::class.java)

            when (call.method) {
                "startService" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(null)
                }
                "stopService" -> {
                    stopService(intent)
                    result.success(null)
                }
                "setKeywords" -> {
                    val args = call.arguments as? List<*>
                    val keywords = args?.mapNotNull { it?.toString() } ?: emptyList()
                    VoiceService.updateExtraKeywords(keywords)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
