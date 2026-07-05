import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/features/home/data/gird_services_data.dart';
import 'package:safe_zone/features/sos/ui/after_sos.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 11)).then((_) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AfterSos()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;
    final provider = context.read<GirdServicesData>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.red[100],
                radius: 50,
                child: Icon(
                  Icons.warning_outlined,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              SizedBox(height: 10),
              Text(
                l10n.are_you_in_danger,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(l10n.confirm_sending_sos_alert_now),
              SizedBox(
                child: Column(
                  spacing: 10,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Fluttertoast.showToast(msg: l10n.confirmed);
                        },
                        child: Text(
                          l10n.confirm_sos,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          provider.cancelSOS();
                          Fluttertoast.showToast(msg: l10n.cancelled);
                          Navigator.pop(context);
                        },
                        child: Text(
                          l10n.cancel,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
