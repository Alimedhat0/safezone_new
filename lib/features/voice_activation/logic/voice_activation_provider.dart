import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_zone/core/services/background_services.dart';
import 'package:safe_zone/features/voice_activation/models/secret_word_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VoiceActivationProvider extends ChangeNotifier {
  VoiceActivationProvider() {
    isBackgroundListening = isVoiceServiceRunning;
  }

  String selectedOption = 'Medium';
  List<String> options = ['Low', 'Medium', 'High'];
  void changeOptions(String value) {
    selectedOption = value;
    notifyListeners();
  }

  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  final TextEditingController keywordController = TextEditingController();

  bool isRecording = false;
  bool isRecorderReady = false;
  bool isSavingKeyword = false;
  bool isBackgroundListening = false;
  bool isTogglingBackgroundListening = false;
  String? _pendingKeyword;

  String? recordedPath;

  Future initRecorder() async {
    if (isRecorderReady) return;

    final status = await Permission.microphone.request();

    if (!status.isGranted) {
      throw Exception("Mic permission denied");
    }

    await recorder.openRecorder();

    recorder.setSubscriptionDuration(const Duration(milliseconds: 200));

    isRecorderReady = true;
  }

  Future<void> toggleKeywordRecording() async {
    if (isSavingKeyword) return;

    if (!isRecording) {
      final keyword = keywordController.text.trim().toLowerCase();
      if (keyword.isEmpty) {
        Fluttertoast.showToast(msg: "Please enter a keyword first");
        return;
      }

      _pendingKeyword = keyword;
      await initRecorder();
      await startRecording();
      return;
    }

    isSavingKeyword = true;
    notifyListeners();

    try {
      final keyword =
          (_pendingKeyword ?? keywordController.text.trim().toLowerCase())
              .trim();
      await stopRecording(keyword: keyword);
      _pendingKeyword = null;
    } finally {
      isSavingKeyword = false;
      notifyListeners();
    }
  }

  Future startRecording() async {
    if (!isRecorderReady) return;

    final dir = await getApplicationDocumentsDirectory();

    recordedPath = "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.aac";

    await recorder.startRecorder(toFile: recordedPath, codec: Codec.aacADTS);

    isRecording = true;
    notifyListeners();
  }

  Future<String?> stopRecording({required String keyword}) async {
    final path = await recorder.stopRecorder();
    isRecording = false;
    if (path != null) {
      try {
        final normalizedKeyword = keyword.trim().toLowerCase();
        if (normalizedKeyword.isEmpty) {
          throw Exception("Keyword is empty");
        }

        final url = await uploadAudio(path);
        await sendToFirebase(url, normalizedKeyword);
        keywordController.clear();
      } catch (e) {
        print("Upload error: $e");
        Fluttertoast.showToast(msg: "Failed to save keyword");
      }
    }
    notifyListeners();
    return path;
  }

  Future<void> toggleBackgroundListening() async {
    if (isTogglingBackgroundListening) return;

    isTogglingBackgroundListening = true;
    notifyListeners();

    final success =
        isBackgroundListening
            ? await stopVoiceService()
            : await startVoiceService();

    if (success) {
      isBackgroundListening = !isBackgroundListening;
    }

    isTogglingBackgroundListening = false;
    notifyListeners();
  }

  final supabase = Supabase.instance.client;
  Future<String> uploadAudio(String path) async {
    final file = File(path);
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    await supabase.storage
        .from('secretword')
        .upload('records/$fileName.aac', file);

    final url = supabase.storage
        .from('secretword')
        .getPublicUrl('records/$fileName.aac');

    return url;
  }

  List<SecretWordModel> audioList = [];

  final FlutterSoundPlayer player = FlutterSoundPlayer();
  Future<void> initPlayer() async {
    await player.openPlayer();
  }

  Future<void> playAudio(String url) async {
    await player.startPlayer(fromURI: url, codec: Codec.aacADTS);
  }

  Future<void> sendToFirebase(String url, String keyword) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();

    final audioFire = SecretWordModel(
      uid: uid,
      path: url,
      keyword: keyword,
      id: messageId,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await FirebaseFirestore.instance
        .collection('secretword')
        .doc(messageId)
        .set(audioFire.toMap());

    await saveAndSyncVoiceKeywords([
      ...audioList.map((item) => item.keyword),
      keyword,
    ]);
  }

  StreamSubscription? _subscription;

  Future<void> getSecretword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _subscription?.cancel();

    _subscription = FirebaseFirestore.instance
        .collection('secretword')
        .where('uid', isEqualTo: user.uid)
        .snapshots()
        .listen((event) {
          // audioList.clear();
          // audioList =
          //     event.docs.map((e) => SecretWordModel.fromMap(e.data())).toList();
          audioList =
              event.docs
                  .map((e) => SecretWordModel.fromMap(e.data(), e.id))
                  .toList();
          audioList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          saveAndSyncVoiceKeywords(audioList.map((item) => item.keyword).toList());

          notifyListeners();
        });
  }

  Future<void> deleteAudio(SecretWordModel audio) async {
    try {
      final uri = Uri.parse(audio.path);
      final filePath = uri.pathSegments.last;

      await supabase.storage.from('secretword').remove(['records/$filePath']);

      await FirebaseFirestore.instance
          .collection('secretword')
          .doc(audio.id)
          .delete();

      await saveAndSyncVoiceKeywords(
        audioList
            .where((item) => item.id != audio.id)
            .map((item) => item.keyword)
            .toList(),
      );
    } catch (e) {
      print("Delete error: $e");
    }
  }

  bool isPlaying = false;

  Future<void> toggleAudio(String url) async {
    if (isPlaying) {
      await player.stopPlayer();
      isPlaying = false;
    } else {
      await player.startPlayer(fromURI: url);
      isPlaying = true;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    player.closePlayer();
    recorder.closeRecorder();
    keywordController.dispose();
    super.dispose();
  }
}
