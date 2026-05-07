package com.example.safe_zone

import android.app.*
import android.content.Intent
import android.os.*
import android.speech.*
import android.speech.RecognitionListener
import android.speech.SpeechRecognizer
import androidx.core.app.NotificationCompat
import io.flutter.plugin.common.MethodChannel

class VoiceService : Service(), RecognitionListener {

    companion object {
        var channel: MethodChannel? = null
        private val defaultKeywords = setOf("help", "sos", "مساعدة", "مساعده", "الحقوني")
        private var extraKeywords: Set<String> = emptySet()

        fun updateExtraKeywords(keywords: List<String>) {
            extraKeywords = keywords
                .map { it.trim().lowercase() }
                .filter { it.isNotEmpty() }
                .toSet()
        }

        private fun allKeywords(): Set<String> = defaultKeywords + extraKeywords
    }

    private lateinit var speechRecognizer: SpeechRecognizer
    private lateinit var intent: Intent
    private val mainHandler = Handler(Looper.getMainLooper())
    private var isStopping = false

    override fun onCreate() {
        super.onCreate()

        startForegroundService()

        speechRecognizer = SpeechRecognizer.createSpeechRecognizer(this)

        intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
        }

        speechRecognizer.setRecognitionListener(this)

        startListening()
    }

    private fun startListening() {
        if (isStopping) return

        try {
            speechRecognizer.startListening(intent)
        } catch (e: Exception) {
            restartListening()
        }
    }

    private fun restartListening() {
        if (isStopping) return

        mainHandler.postDelayed({
            if (isStopping) return@postDelayed
            speechRecognizer.cancel()
            speechRecognizer.startListening(intent)
        }, 1500)
    }

    override fun onResults(results: Bundle?) {
        val data = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
        val text = data?.get(0)?.lowercase() ?: ""

        if (allKeywords().any { keyword -> text.contains(keyword) }) {
            channel?.invokeMethod("onVoiceDetected", text)
        }

        restartListening()
    }

    override fun onError(error: Int) {
        restartListening()
    }

    override fun onReadyForSpeech(params: Bundle?) {}
    override fun onBeginningOfSpeech() {}
    override fun onRmsChanged(rmsdB: Float) {}
    override fun onBufferReceived(buffer: ByteArray?) {}
    override fun onEndOfSpeech() {}
    override fun onPartialResults(partialResults: Bundle?) {}
    override fun onEvent(eventType: Int, params: Bundle?) {}

    private fun startForegroundService() {
        val channelId = "voice_service"

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Voice Service",
                NotificationManager.IMPORTANCE_LOW
            )

            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }

        val notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Listening...")
            .setContentText("SOS detection active")
            .setSmallIcon(android.R.drawable.ic_btn_speak_now)
            .build()

        startForeground(1, notification)
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        isStopping = true
        mainHandler.removeCallbacksAndMessages(null)
        if (::speechRecognizer.isInitialized) {
            speechRecognizer.cancel()
            speechRecognizer.destroy()
        }
        stopForeground(true)
        super.onDestroy()
    }
}
