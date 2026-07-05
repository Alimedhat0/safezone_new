import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:safe_zone/features/notification/models/notification_model.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';

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

  Future<void> showNotification({String? title, String? body}) async {
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
      title: title ?? 'SOS Alert',
      body: body ?? 'Emergency triggered!',
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
    AppLocalizations? l10n,
  }) async {
    final trustedResult =
        await _firestore
            .collection('users')
            .doc(senderUid)
            .collection('trustedContacts')
            .get();

    if (trustedResult.docs.isEmpty) return;

    final senderDoc = await _firestore.collection('users').doc(senderUid).get();
    final senderName = senderDoc.data()?['name'] ?? l10n?.someone ?? 'Someone';
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
        title: l10n?.sos_alert_notification_title ?? 'SOS Alert',
        body:
            l10n?.needs_help_location(senderName, mapUrl) ??
            '$senderName needs help. Location: $mapUrl',
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

  Future<void> scheduleNotification({AppLocalizations? l10n}) async {
    await notificationsPlugin.periodicallyShow(
      0,
      l10n?.are_you_safe ?? 'Are you safe?',
      l10n?.scheduled_safety_check ?? 'Are you okay? Do you need help?',
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
      'speech_service',
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
