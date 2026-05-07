import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_zone/features/home/data/gird_services_data.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GirdServicesData _service = GirdServicesData();

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  print("✅ Flutter Background Service Running");
}

const platform = MethodChannel('voice_service');
bool _isHandlingVoiceTrigger = false;
bool _isVoiceServiceRunning = false;
const String _voiceKeywordsPrefsKey = 'voice_keywords';

bool get isVoiceServiceRunning => _isVoiceServiceRunning;

List<String> _normalizeKeywords(Iterable<String> keywords) {
  final seen = <String>{};
  final normalized = <String>[];

  for (final keyword in keywords) {
    final value = keyword.trim().toLowerCase();
    if (value.isEmpty || seen.contains(value)) continue;
    seen.add(value);
    normalized.add(value);
  }

  return normalized;
}

Future<List<String>> getStoredVoiceKeywords() async {
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getStringList(_voiceKeywordsPrefsKey) ?? [];
  return _normalizeKeywords(stored);
}

Future<void> pushVoiceKeywordsToNative(List<String> keywords) async {
  final normalized = _normalizeKeywords(keywords);

  try {
    await platform.invokeMethod('setKeywords', normalized);
  } on MissingPluginException {
    print("⚠️ Voice keywords sync skipped (plugin not ready)");
  } on PlatformException catch (e) {
    print("❌ Failed to sync voice keywords: ${e.message}");
  }
}

Future<void> saveAndSyncVoiceKeywords(List<String> keywords) async {
  final normalized = _normalizeKeywords(keywords);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(_voiceKeywordsPrefsKey, normalized);
  await pushVoiceKeywordsToNative(normalized);
}

Future<void> clearVoiceKeywords() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_voiceKeywordsPrefsKey);
  await pushVoiceKeywordsToNative(const []);
}

Future<bool> startVoiceService() async {
  final microphoneStatus = await Permission.microphone.request();
  if (!microphoneStatus.isGranted) {
    print("❌ Microphone permission denied");
    return false;
  }

  await Permission.notification.request();

  try {
    final storedKeywords = await getStoredVoiceKeywords();
    await pushVoiceKeywordsToNative(storedKeywords);
    await platform.invokeMethod('startService');
    print("✅ Native voice service started");
    _isVoiceServiceRunning = true;
    return true;
  } on MissingPluginException {
    print("❌ Voice service plugin is not available on this platform");
    return false;
  } on PlatformException catch (e) {
    print("❌ Failed to start voice service: ${e.message}");
    return false;
  }
}

Future<bool> stopVoiceService() async {
  try {
    await platform.invokeMethod('stopService');
    print("✅ Native voice service stopped");
    _isVoiceServiceRunning = false;
    return true;
  } on MissingPluginException {
    print("⚠️ Voice service plugin is not available on this platform");
    _isVoiceServiceRunning = false;
    return false;
  } on PlatformException catch (e) {
    print("❌ Failed to stop voice service: ${e.message}");
    return false;
  }
}

Future<void> _handleVoiceDetected(String text) async {
  if (_isHandlingVoiceTrigger) return;

  _isHandlingVoiceTrigger = true;
  final shouldRestartVoiceService = _isVoiceServiceRunning;

  try {
    if (shouldRestartVoiceService) {
      await stopVoiceService();
      await Future.delayed(const Duration(milliseconds: 700));
    }

    await _service.triggerVoiceSos();
  } catch (e) {
    print("❌ Voice SOS failed: $e");
  } finally {
    if (shouldRestartVoiceService) {
      await startVoiceService();
    }

    _isHandlingVoiceTrigger = false;
  }
}

void listenToVoice() {
  platform.setMethodCallHandler((call) async {
    if (call.method == "onVoiceDetected") {
      final text = call.arguments?.toString() ?? "";
      print("🚨 SOS voice trigger: $text");
      await _handleVoiceDetected(text);
    }
  });
}
