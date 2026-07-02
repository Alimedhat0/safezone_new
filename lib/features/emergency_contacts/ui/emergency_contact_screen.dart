import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/features/emergency_contacts/logic/emergency_provider.dart';

class EmergencyContactScreen extends StatelessWidget {
  const EmergencyContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;

    return ChangeNotifierProvider(
      create: (context) => EmergencyProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.emergency_contacts)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.emergency_sos,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Consumer<EmergencyProvider>(
                builder: (context, provider, child) {
                  final emergencyData = provider.localizedEmergencyData(l10n);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 10,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: emergencyData.length,
                      itemBuilder: (context, index) {
                        final emerg = emergencyData[index];
                        return Column(
                          spacing: 5,
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                SvgPicture.asset(emerg.image),
                                Expanded(
                                  child: Column(
                                    spacing: 5,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        emerg.phone,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        emerg.type,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    provider.launchPhone(emerg.phone);
                                  },
                                  icon: Icon(Icons.call, color: Colors.grey),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                              ),
                              child: Divider(thickness: 2),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
