import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/aspict/app_aspict.dart';
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
                          height: screenHeight * 0.3,
                          child: Card(
                            elevation: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                spacing: 15,
                                children: [
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
                                        provider.audioList.length >= 2
                                            ? null
                                            : () async {
                                              if (!provider.isRecording) {
                                                await provider.initRecorder();
                                                await provider.startRecording();
                                              } else {
                                                final path =
                                                    await provider
                                                        .stopRecording();
                                                if (path != null) {}
                                              }
                                            },
                                    child:
                                        provider.isRecording
                                            ? Text(
                                              'Recording...',
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
                        // Preview your recorded keyword
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
                                            child: IconButton(
                                              onPressed: () async {
                                                await provider.initPlayer();
                                                await provider.playAudio(
                                                  provider
                                                      .audioList[index]
                                                      .path,
                                                );
                                              },
                                              icon: Icon(Icons.play_arrow),
                                            ),
                                          ),
                                          title: Text(
                                            'Preview your recorded keyword',
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
                                            onPressed: () async {
                                              await provider.initPlayer();
                                              await provider.playAudio(
                                                provider.audioList[index].path,
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

                        // Detection Sensitivity
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
                        if (provider.audioList.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {},
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
