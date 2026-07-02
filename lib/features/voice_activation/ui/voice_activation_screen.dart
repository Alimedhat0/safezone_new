import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/voice_activation/logic/voice_activation_provider.dart';

class VoiceActivationScreen extends StatelessWidget {
  const VoiceActivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VoiceActivationProvider()..getSecretword(),
      child: Scaffold(
        appBar: AppBar(title: Text('Voice Activation'), centerTitle: true),
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
                        Text('Set Your Emegency Keyword'),
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
                                      labelText: 'Keyword you will say',
                                      hintText: 'ex: help me',
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
                                              'Saving...',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                            : provider.isRecording
                                            ? Text(
                                              'Tap to Save Keyword',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                            : Text(
                                              'Tap to Record your keyword',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                  ),
                                  Text('Recommended: 1–2 words only'),
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
                                            'Preview your recorded keyword',
                                          ),
                                          subtitle:
                                              provider
                                                      .audioList[index]
                                                      .keyword
                                                      .isEmpty
                                                  ? null
                                                  : Text(
                                                    'Keyword: ${provider.audioList[index].keyword}',
                                                  ),
                                          trailing: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "Delete Audio?",
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            () => Navigator.pop(
                                                              dialogContext,
                                                            ),
                                                        child: Text("Cancel"),
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
                                                        child: Text("Delete"),
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
                                                msg: 'Saved Successfully',
                                              );
                                            },
                                            child: Text(
                                              'Confirm Keyword',
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

                        Text('Detection Sensitivity'),
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
                                      child: Text(item),
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
                                  ? 'Please wait...'
                                  : provider.isBackgroundListening
                                  ? 'Stop Background Listening'
                                  : 'Start Background Listening',
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
                                'Test Voice Trigger',
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
