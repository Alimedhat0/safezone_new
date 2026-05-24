import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/home/data/gird_services_data.dart';
import 'package:safe_zone/main.dart';

class AfterSos extends StatefulWidget {
  const AfterSos({super.key});

  @override
  State<AfterSos> createState() => _AfterSosState();
}

class _AfterSosState extends State<AfterSos> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainApp()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              CircleAvatar(
                backgroundColor: Colors.green[50],
                radius: 70,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.green[200],
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
              Text(
                'SOS Alert Sent',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Your location and voice snippet have been shared'),
              Consumer<GirdServicesData>(
                builder: (context, provider, _) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(8),
                        elevation: 6,
                        child: Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.circle, color: Colors.green, size: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              child: Column(
                                spacing: 10,
                                children: [
                                  Text(
                                    provider.afterSos[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    provider.afterSos[index].subtitle,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: provider.afterSos.length,
                  );
                },
              ),
              Text(
                'Your SOS is now active. Your contacts can see your live location and listen to your voice note.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
