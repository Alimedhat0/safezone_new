import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/aspict/app_aspict.dart';
import 'package:safe_zone/features/emergency_trigger/logic/emegency_trigger_provider.dart';
import 'package:safe_zone/features/voice_activation/ui/voice_activation_screen.dart';

class EmergencyTriggerScreen extends StatelessWidget {
  const EmergencyTriggerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmegencyTriggerProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text('Emergency Trigger'), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Your Emergency Trigger',
                style: TextStyle(fontSize: 16),
              ),
              Column(
                spacing: 16,
                children: [
                  // SizedBox(
                  //   width: double.infinity,
                  //   height: screenHeight * 0.15,
                  //   child: Card(
                  //     elevation: 6,
                  //     child: ListTile(
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => TrustedContactScreen(),
                  //           ),
                  //         );
                  //       },
                  //       leading: Icon(Icons.mic_none_outlined),
                  //       title: Text('Voice'),
                  //       subtitle: Text(
                  //         'Trigger SOS when you say a secret word',
                  //       ),
                  //       trailing: IconButton(
                  //         onPressed: () {},
                  //         icon: Icon(Icons.arrow_forward_ios),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.15,
                    child: Card(
                      // color: Colors.white,
                      elevation: 6,
                      semanticContainer: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        spacing: 10,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: CircleAvatar(
                              child: Icon(Icons.mic_none_rounded),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Voice Activation',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Trigger SOS when you say a secret keyword',
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VoiceActivationScreen(),
                                ),
                              );
                            },
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Consumer<EmegencyTriggerProvider>(
                    builder: (context, provider, _) {
                      return Column(
                        spacing: 16,
                        children: [
                          Card(
                            elevation: 6,
                            child: SwitchListTile(
                              value: provider.settings['shake'] ?? false,
                              onChanged: (value) {
                                provider.updateSetting('shake', value);
                              },
                              title: Text(
                                'Shake The Phone',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Shake your phone vigorously to send an emergency alert',
                              ),
                              secondary: CircleAvatar(
                                child: Icon(Icons.vibration),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 6,
                            child: SwitchListTile(
                              value: provider.powerButton,
                              onChanged: (value) {
                                provider.togglepower(value);
                              },
                              title: Text(
                                'Press Power Button 3 \nTimes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Quickly press the power button three times to trigger SOS',
                              ),
                              secondary: CircleAvatar(
                                child: Icon(Icons.phone_android_outlined),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                elevation: 4,
                              ),
                              onPressed: () {},
                              child: Text(
                                'Test Trigger',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 6,
                            child: ListTile(
                              tileColor: Color(0xffFFFBED),
                              leading: Icon(
                                Icons.warning,
                                color: Color(0xffD56F15),
                              ),
                              title: Text(
                                'Use triggers carefully to avoid false alerts.',
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
