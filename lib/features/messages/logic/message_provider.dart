import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart' show Codec;
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_zone/features/messages/models/message_model.dart';
import 'package:safe_zone/features/register/model/register_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageProvider extends ChangeNotifier {
  final messageController = TextEditingController();

  void sendMessage(RegisterModel receiverUser) async {
    if (messageController.text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final messageId = DateTime.now().millisecondsSinceEpoch.toString();

    final message = MessageModel(
      id: messageId,
      receiverName: receiverUser.name,
      receiverUid: receiverUser.uid,
      senderName: user.displayName ?? '',
      senderUid: user.uid,
      createdAt: DateTime.now().toString(),
      content: messageController.text,
      type: 'text',
    );

    await FirebaseFirestore.instance
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    messageController.clear();
  }

  List<MessageModel> messages = [];
  void getAllMessages(RegisterModel receiverUser) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    FirebaseFirestore.instance
        .collection("messages")
        .where('receiverUid', whereIn: [user.uid, receiverUser.uid])
        .where('senderUid', whereIn: [user.uid, receiverUser.uid])
        .snapshots()
        .listen((event) {
          messages.clear();
          final docs = event.docs;
          for (var doc in docs) {
            final message = MessageModel.fromMap(doc.data());
            print(message.senderName);
            messages.add(message);
          }
          notifyListeners();
        });
  }

  final FlutterSoundRecorder recorder = FlutterSoundRecorder();

  bool isRecording = false;
  bool isRecorderReady = false;

  String? recordedPath;

  Future initRecorder() async {
    await Permission.microphone.request();

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

  Future stopRecording(RegisterModel receiverUser) async {
    await recorder.stopRecorder();

    isRecording = false;
    notifyListeners();

    if (recordedPath != null) {
      final url = await uploadVoice(recordedPath!);

      sendMessageModel(url, receiverUser);
    }
  }

  Future<String> uploadVoice(String path) async {
    final supabase = Supabase.instance.client;

    final file = File(path);

    final fileName = "${DateTime.now().millisecondsSinceEpoch}.aac";

    await supabase.storage
        .from('voices')
        .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

    final url = supabase.storage.from('voices').getPublicUrl(fileName);
    print(url);
    return url;
  }

  void sendMessageModel(String audioUrl, RegisterModel receiverUser) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final message = MessageModel(
      id: messageId,
      receiverName: receiverUser.name,
      receiverUid: receiverUser.uid,
      senderName: user.displayName ?? '',
      senderUid: user.uid,
      createdAt: DateTime.now().toString(),
      content: audioUrl,
      type: 'voice',
    );

    await FirebaseFirestore.instance
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  final FlutterSoundPlayer player = FlutterSoundPlayer();

  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  String? currentPlayingUrl;

  Future initPlayer() async {
    await player.openPlayer();

    player.onProgress!.listen((event) {
      position = event.position;
      duration = event.duration;
      notifyListeners();
    });
  }

  Future playVoice(String url) async {
    if (currentPlayingUrl == url && isPlaying) {
      await player.pausePlayer();
      isPlaying = false;
    } else {
      await player.startPlayer(
        fromURI: url,
        codec: Codec.aacADTS,
        whenFinished: () {
          isPlaying = false;
          position = Duration.zero;
          notifyListeners();
        },
      );

      currentPlayingUrl = url;
      isPlaying = true;
    }

    notifyListeners();
  }

  String formatDuration(Duration d) {
    String minutes = d.inMinutes.toString().padLeft(2, '0');

    String seconds = (d.inSeconds % 60).toString().padLeft(2, '0');

    return "$minutes:$seconds";
  }
}
