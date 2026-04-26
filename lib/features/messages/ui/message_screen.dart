import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/widgets/custom_text_field.dart';
import 'package:safe_zone/features/messages/logic/message_provider.dart';
import 'package:safe_zone/features/messages/widgets/voice_bubble.dart';
import 'package:safe_zone/features/register/model/register_model.dart';

class MessageScreen extends StatelessWidget {
  final RegisterModel registerModel;
  const MessageScreen({super.key, required this.registerModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) =>
              MessageProvider()
                ..getAllMessages(registerModel)
                ..initPlayer(),
      builder:
          (context, child) => Scaffold(
            appBar: AppBar(title: Text(registerModel.name)),
            body: Consumer<MessageProvider>(
              builder: (context, provider, _) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              final dateTime = DateTime.parse(
                                provider.messages[index].createdAt,
                              );
                              final dateFormatted = DateFormat.Hms().format(
                                dateTime,
                              );

                              bool isSender =
                                  provider.messages[index].senderUid ==
                                  FirebaseAuth.instance.currentUser!.uid;

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    isSender
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color:
                                            isSender
                                                ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                                : Colors.grey[100],
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                          bottomLeft: Radius.circular(
                                            isSender ? 12 : 0,
                                          ),
                                          bottomRight: Radius.circular(
                                            isSender ? 0 : 12,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          // Text(
                                          //   provider.messages[index].content,
                                          //   style: TextStyle(
                                          //     color:
                                          //         isSender
                                          //             ? Colors.white
                                          //             : Colors.black,
                                          //   ),
                                          // ),
                                          provider.messages[index].type ==
                                                  'voice'
                                              ? VoiceBubble(
                                                audioUrl:
                                                    provider
                                                        .messages[index]
                                                        .content,
                                                isSender: isSender,
                                              )
                                              : Text(
                                                provider
                                                    .messages[index]
                                                    .content,
                                                style: TextStyle(
                                                  color:
                                                      isSender
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),

                                          Text(
                                            dateFormatted,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color:
                                                  isSender
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder:
                                (context, index) => SizedBox(height: 5),
                            itemCount: provider.messages.length,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: provider.messageController,
                                text: 'Enter Message here',
                              ),
                            ),

                            IconButton(
                              icon: Icon(
                                provider.isRecording ? Icons.stop : Icons.mic,
                              ),
                              onPressed: () async {
                                if (provider.isRecording) {
                                  await provider.stopRecording(registerModel);
                                } else {
                                  await provider.initRecorder();
                                  await provider.startRecording();
                                }
                              },
                            ),

                            IconButton(
                              onPressed: () {
                                provider.sendMessage(registerModel);
                              },
                              icon: Icon(
                                Icons.send,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
    );
  }
}
 // GestureDetector(
                            //   onLongPress: () {
                            //     provider.initRecorder();
                            //     provider.startRecording();
                            //   },
                            //   onLongPressUp: () async {
                            //     String? path = await provider.stopRecording();
                            //     if (path != null) {
                            //     }
                            //   },
                            //   child: Icon(Icons.mic),
                            // ),
                                                                    // if (provider.voiceMessages.isNotEmpty)
                                        //   Container(
                                        //     padding: EdgeInsets.all(10),
                                        //     margin: EdgeInsets.symmetric(
                                        //       vertical: 5,
                                        //     ),
                                        //     decoration: BoxDecoration(
                                        //       color: Colors.green.shade400,
                                        //       borderRadius: BorderRadius.only(
                                        //         topLeft: Radius.circular(16),
                                        //         topRight: Radius.circular(16),
                                        //         bottomLeft: Radius.circular(16),
                                        //       ),
                                        //     ),

                                        //     child: Row(
                                        //       children: [
                                        //         /// زر التشغيل
                                        //         IconButton(
                                        //           icon: Icon(
                                        //             provider.isPlaying &&
                                        //                     provider.currentPlayingUrl ==
                                        //                         provider
                                        //                             .voiceMessages[index]
                                        //                             .content
                                        //                 ? Icons.pause
                                        //                 : Icons.play_arrow,
                                        //             color: Colors.white,
                                        //           ),

                                        //           onPressed: () {
                                        //             provider.playVoice(
                                        //               provider
                                        //                   .voiceMessages[index]
                                        //                   .content,
                                        //             );
                                        //           },
                                        //         ),

                                        //         /// progress bar
                                        //         Expanded(
                                        //           child: Slider(
                                        //             value:
                                        //                 isCurrent
                                        //                     ? provider
                                        //                         .position
                                        //                         .inSeconds
                                        //                         .toDouble()
                                        //                     : 0,
                                        //             max:
                                        //                 isCurrent
                                        //                     ? (provider
                                        //                                 .duration
                                        //                                 .inSeconds ==
                                        //                             0
                                        //                         ? 1
                                        //                         : provider
                                        //                             .duration
                                        //                             .inSeconds
                                        //                             .toDouble())
                                        //                     : 1,
                                        //             onChanged: (_) {},
                                        //           ),
                                        //         ),

                                        //         /// مدة الصوت
                                        //         Text(
                                        //           provider.formatDuration(
                                        //             provider.duration,
                                        //           ),
                                        //           style: TextStyle(
                                        //             color: Colors.white,
                                        //           ),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),