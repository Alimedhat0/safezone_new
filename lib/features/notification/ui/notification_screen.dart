import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/features/notification/logic/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().listenToNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notifications)),
      body: Column(
        children: [
          Consumer<NotificationProvider>(
            builder: (context, provider, _) {
              if (provider.notifications.isEmpty) {
                return Center(child: Text(l10n.no_notifications));
              }
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: provider.notifications.length,
                itemBuilder: (context, index) {
                  final notif = provider.notifications[index];

                  return Card(
                    child: ListTile(
                      title: Text(notif.title),
                      subtitle: Text(notif.body),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
