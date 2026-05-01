import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

    await _firestore.collection('notifications').doc(id).set(notif.toMap());

    await notificationsPlugin.show(0, notif.title, notif.body, details);
  }

  final _firestore = FirebaseFirestore.instance;

  List<NotificationModel> notifications = [];

  Future<void> addNotification(String title, String body) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final notif = NotificationModel(
      id: id,
      title: title,
      body: body,
      date: DateTime.now(),
    );

    await _firestore.collection('notifications').doc(id).set(notif.toMap());
  }

  StreamSubscription? _sub;

  void listenToNotifications() {
    _sub?.cancel();

    _sub = _firestore
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
}
