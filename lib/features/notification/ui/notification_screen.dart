// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:safe_zone/features/notification/logic/notification_provider.dart';

// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Notifications'), centerTitle: true),
//       body: Column(
//         children: [
//           Consumer<NotificationProvider>(
//             builder: (context, provider, _) {
//               return ElevatedButton(
//                 onPressed: () {
//                   provider.showNotification();
//                 },
//                 child: Text("Test Notification"),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/notification/logic/notification_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: Column(
        children: [
          Consumer<NotificationProvider>(
            builder: (context, provider, _) {
              return ElevatedButton(
                onPressed: () {
                  provider.showNotification();
                },
                child: Text("Test Notification"),
              );
            },
          ),

          // Consumer<NotificationProvider>(
          //   builder: (context, provider, _) {
          //     if (provider.notifications.isEmpty) {
          //       return Center(child: Text("No notifications yet"));
          //     }

          //     return ListView.builder(
          //       shrinkWrap: true,
          //       itemCount: provider.notifications.length,
          //       itemBuilder: (context, index) {
          //         final notif = provider.notifications[index];

          //         return Card(
          //           child: ListTile(
          //             leading: Icon(Icons.notifications),
          //             title: Text(notif.title),
          //             subtitle: Text(notif.body),
          //             trailing: Text("${notif.date.hour}:${notif.date.minute}"),
          //           ),
          //         );
          //       },
          //     );
          //   },
          // ),
          Consumer<NotificationProvider>(
            builder: (context, provider, _) {
              if (provider.notifications.isEmpty) {
                return Center(child: Text("No notifications"));
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
