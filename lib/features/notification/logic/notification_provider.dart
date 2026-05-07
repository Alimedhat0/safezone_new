import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:safe_zone/features/notification/models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await notificationsPlugin.initialize(settings);
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      await _saveFcmToken(token);
    });
  }

  Future<void> saveCurrentUserFcmToken() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    await _saveFcmToken(token);
  }

  Future<void> _saveFcmToken(String token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).set({
      'fcmToken': token,
      'fcmTokenUpdatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<void> showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final notif = NotificationModel(
      id: id,
      title: 'SOS Alert 🚨',
      body: 'Emergency triggered!',
      date: DateTime.now(),
    );

    notifications.insert(0, notif);
    notifyListeners();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc(id)
          .set(notif.toMap());
    }

    await notificationsPlugin.show(0, notif.title, notif.body, details);
  }

  final _firestore = FirebaseFirestore.instance;

  List<NotificationModel> notifications = [];

  Future<void> addNotification(String title, String body) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final notif = NotificationModel(
      id: id,
      title: title,
      body: body,
      date: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .doc(id)
        .set(notif.toMap());
  }

  Future<void> sendSosAlertToTrustedContacts({
    required String senderUid,
    required double lat,
    required double lon,
  }) async {
    final trustedResult =
        await _firestore
            .collection('users')
            .doc(senderUid)
            .collection('trustedContacts')
            .get();

    if (trustedResult.docs.isEmpty) return;

    final senderDoc = await _firestore.collection('users').doc(senderUid).get();
    final senderName = senderDoc.data()?['name'] ?? 'Someone';
    final mapUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';

    final batch = _firestore.batch();
    final now = DateTime.now();

    for (final trustedDoc in trustedResult.docs) {
      final notificationRef =
          _firestore
              .collection('users')
              .doc(trustedDoc.id)
              .collection('notifications')
              .doc();

      final notif = NotificationModel(
        id: notificationRef.id,
        title: 'SOS Alert',
        body: '$senderName needs help. Location: $mapUrl',
        date: now,
      );

      batch.set(notificationRef, notif.toMap());
    }

    await batch.commit();
  }

  StreamSubscription? _sub;

  void listenToNotifications() {
    _sub?.cancel();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _sub = _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((event) {
          notifications =
              event.docs
                  .map((e) => NotificationModel.fromMap(e.data(), e.id))
                  .toList();

          notifyListeners();
        });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> scheduleNotification() async {
    await notificationsPlugin.periodicallyShow(
      0,
      'Are you safe?',
      'هل انت بخير؟ هل تحتاج مساعدة؟',
      RepeatInterval.hourly,
      const NotificationDetails(
        android: AndroidNotificationDetails('channel_id', 'channel_name'),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> setupNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'speech_service', // ⚠️ لازم نفس الـ ID
      'Speech Background Service',
      description: 'Used for background voice listening',
      importance: Importance.low,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }
}
