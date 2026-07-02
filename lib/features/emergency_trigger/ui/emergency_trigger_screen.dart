import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/aspict/app_aspict.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/features/emergency_trigger/logic/emegency_trigger_provider.dart';
import 'package:safe_zone/features/voice_activation/ui/voice_activation_screen.dart';

class EmergencyTriggerScreen extends StatelessWidget {
  const EmergencyTriggerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;

    return ChangeNotifierProvider(
      create: (context) => EmegencyTriggerProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.emergency_trigger), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.choose_your_emergency_trigger,
                style: TextStyle(fontSize: 16),
              ),
              Column(
                spacing: 16,
                children: [
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
                                  l10n.voice_activation,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  l10n.trigger_sos_secret_keyword,
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
                              activeTrackColor: Colors.blue,
                              value: provider.settings['shake'] ?? false,
                              onChanged: (value) {
                                provider.updateSetting('shake', value);
                              },
                              title: Text(
                                l10n.shake_the_phone,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                l10n.shake_phone_to_send_alert,
                              ),
                              secondary: CircleAvatar(
                                child: Icon(Icons.vibration),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 6,
                            child: SwitchListTile(
                              activeTrackColor: Colors.blue,
                              value: provider.settings['power'] ?? false,
                              onChanged: (value) {
                                provider.updateSetting('power', value);
                              },
                              title: Text(
                                l10n.press_power_button_three_times,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                l10n.press_power_button_to_trigger_sos,
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
                              onPressed:
                                  provider.isTestingTrigger
                                      ? null
                                      : () => provider.testDefaultTrigger(l10n),
                              child: Text(
                                l10n.test_trigger,
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
                                l10n.use_triggers_carefully,
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
