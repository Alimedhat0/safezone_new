import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_zone/features/voice_activation/models/secret_word_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VoiceActivationProvider extends ChangeNotifier {
  String selectedOption = 'Medium';
  List<String> options = ['Low', 'Medium', 'High'];
  void changeOptions(String value) {
    selectedOption = value;
    notifyListeners();
  }

  final FlutterSoundRecorder recorder = FlutterSoundRecorder();

  bool isRecording = false;
  bool isRecorderReady = false;

  String? recordedPath;

  Future initRecorder() async {
    // await Permission.microphone.request();
    final status = await Permission.microphone.request();

    if (!status.isGranted) {
      throw Exception("Mic permission denied");
    }

    await recorder.openRecorder();

    recorder.setSubscriptionDuration(const Duration(milliseconds: 200));

    isRecorderReady = true;
  }

  Future startRecording() async {
    if (!isRecorderReady) return;

    final dir = await getApplicationDocumentsDirectory();

    recordedPath = "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.aac";

    await recorder.startRecorder(toFile: recordedPath, codec: Codec.aacADTS);

    isRecording = true;
    notifyListeners();
  }

  Future<String?> stopRecording() async {
    final path = await recorder.stopRecorder();
    isRecording = false;
    if (path != null) {
      try {
        final url = await uploadAudio(path);
        await sendToFirebase(url);
      } catch (e) {
        print("Upload error: $e");
      }
    }
    notifyListeners();
    return path;
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

  Future<void> sendToFirebase(String url) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();

    final audioFire = SecretWordModel(uid: uid, path: url, id: messageId);

    await FirebaseFirestore.instance
        .collection('secretword')
        .doc(messageId)
        .set(audioFire.toMap());
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

          // for (var doc in event.docs) {
          //   final secretword = SecretWordModel.fromMap(doc.data(), doc.id);
          //   audioList.add(secretword);
          // }

          notifyListeners();
        });
  }

  Future<void> deleteAudio(SecretWordModel audio) async {
    try {
      // 🗑️ 1. حذف من Supabase
      final uri = Uri.parse(audio.path);
      final filePath = uri.pathSegments.last;

      await supabase.storage.from('secretword').remove(['records/$filePath']);

      // 🗑️ 2. حذف من Firestore
      await FirebaseFirestore.instance
          .collection('secretword')
          .doc(audio.id)
          .delete();
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
    super.dispose();
  }
}
