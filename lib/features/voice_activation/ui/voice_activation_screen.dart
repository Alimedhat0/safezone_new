import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/features/voice_activation/logic/voice_activation_provider.dart';

class VoiceActivationScreen extends StatelessWidget {
  const VoiceActivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;

    String sensitivityLabel(String value) {
      switch (value) {
        case 'Low':
          return l10n.low;
        case 'High':
          return l10n.high;
        default:
          return l10n.medium;
      }
    }

    return ChangeNotifierProvider(
      create: (context) => VoiceActivationProvider()..getSecretword(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.voice_activation), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<VoiceActivationProvider>(
                  builder: (context, provider, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Text(l10n.set_your_emergency_keyword),
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                spacing: 15,
                                children: [
                                  TextField(
                                    controller: provider.keywordController,
                                    decoration: InputDecoration(
                                      labelText: l10n.keyword_you_will_say,
                                      hintText: l10n.keyword_example,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor:
                                        provider.isRecording
                                            ? Colors.red[100]
                                            : const Color.fromARGB(
                                              255,
                                              201,
                                              216,
                                              242,
                                            ),
                                    radius: 50,
                                    child: Icon(
                                      Icons.mic_none,
                                      size: 40,
                                      color:
                                          provider.isRecording
                                              ? Colors.red
                                              : Colors.blue,
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          provider.isRecording
                                              ? Colors.grey
                                              : Colors.blue,
                                    ),
                                    onPressed:
                                        provider.isSavingKeyword
                                            ? null
                                            : () async {
                                              await provider
                                                  .toggleKeywordRecording(
                                                    context,
                                                  );
                                            },
                                    child:
                                        provider.isSavingKeyword
                                            ? Text(
                                              l10n.saving,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                            : provider.isRecording
                                            ? Text(
                                              l10n.tap_to_save_keyword,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                            : Text(
                                              l10n.tap_to_record_keyword,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                  ),
                                  Text(l10n.recommended_one_or_two_words),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Consumer<VoiceActivationProvider>(
                          builder: (context, _, _) {
                            if (provider.audioList.isEmpty) {
                              return SizedBox();
                            }
                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: provider.audioList.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.greenAccent,
                                            child: IconButton(
                                              onPressed: () async {
                                                await provider.initPlayer();
                                                await provider.playAudio(
                                                  provider
                                                      .audioList[index]
                                                      .path,
                                                );
                                              },
                                              icon: Icon(
                                                Icons.play_arrow_outlined,
                                                color: Colors.green,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            l10n.preview_recorded_keyword,
                                          ),
                                          subtitle:
                                              provider
                                                      .audioList[index]
                                                      .keyword
                                                      .isEmpty
                                                  ? null
                                                  : Text(
                                                    l10n.keyword_label(
                                                      provider
                                                          .audioList[index]
                                                          .keyword,
                                                    ),
                                                  ),
                                          trailing: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      l10n.delete_audio,
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            () => Navigator.pop(
                                                              dialogContext,
                                                            ),
                                                        child: Text(
                                                          l10n.cancel,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          provider.deleteAudio(
                                                            provider
                                                                .audioList[index],
                                                          );
                                                          Navigator.pop(
                                                            dialogContext,
                                                          );
                                                        },
                                                        child: Text(
                                                          l10n.delete,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                            ),
                                            onPressed: () {
                                              Fluttertoast.showToast(
                                                msg: l10n.saved_successfully,
                                              );
                                            },
                                            child: Text(
                                              l10n.confirm_keyword,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        Text(l10n.detection_sensitivity),
                        DropdownButtonFormField<String>(
                          value: provider.selectedOption,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          items:
                              provider.options
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(sensitivityLabel(item)),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            provider.selectedOption = value!;
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  provider.isBackgroundListening
                                      ? Colors.red
                                      : Colors.blue,
                            ),
                            onPressed:
                                provider.isTogglingBackgroundListening
                                    ? null
                                    : provider.toggleBackgroundListening,
                            icon: Icon(
                              provider.isBackgroundListening
                                  ? Icons.stop
                                  : Icons.hearing,
                              color: Colors.white,
                            ),
                            label: Text(
                              provider.isTogglingBackgroundListening
                                  ? l10n.please_wait
                                  : provider.isBackgroundListening
                                  ? l10n.stop_background_listening
                                  : l10n.start_background_listening,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        if (provider.audioList.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: null,
                              child: Text(
                                l10n.test_voice_trigger,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
