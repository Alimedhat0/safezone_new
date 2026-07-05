import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
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
            // backgroundColor: const Color(0xffF8FAFC),
            appBar: _buildAppBar(context),
            body: Consumer<MessageProvider>(
              builder: (context, provider, _) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Expanded(
                          child:
                              provider.messages.isEmpty
                                  ? _buildEmptyState(context)
                                  : ListView.builder(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 12,
                                    ),
                                    itemCount: provider.messages.length,
                                    itemBuilder: (context, index) {
                                      final message = provider.messages[index];
                                      final dateTime = DateTime.parse(
                                        message.createdAt,
                                      );
                                      final timeFormatted = DateFormat.jm()
                                          .format(dateTime);

                                      final isSender =
                                          message.senderUid ==
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid;

                                      return _buildMessageBubble(
                                        context: context,
                                        message: message.content,
                                        time: timeFormatted,
                                        isSender: isSender,
                                        messageType: message.type,
                                        audioUrl: message.content,
                                      );
                                    },
                                  ),
                        ),

                        _buildInputBar(context, provider),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.1),
            child: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                registerModel.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1E293B),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    context.tr.online,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Color(0xff64748B)),
          onPressed: null,
        ),
      ],
    );
  }

  Widget _buildMessageBubble({
    required BuildContext context,
    required String message,
    required String time,
    required bool isSender,
    required String? messageType,
    required String audioUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.person, size: 16, color: Colors.grey),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isSender
                        ? Color.fromRGBO(74, 144, 226, 1)
                        : Color.fromRGBO(224, 224, 224, 1),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isSender ? 16 : 4),
                  bottomRight: Radius.circular(isSender ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  messageType == 'voice'
                      ? VoiceBubble(audioUrl: audioUrl, isSender: isSender)
                      : Text(
                        message,
                        style: TextStyle(
                          color:
                              isSender ? Colors.white : const Color(0xff1E293B),
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      time,
                      style: TextStyle(
                        color:
                            isSender
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey.shade500,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSender) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 14,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = context.tr;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.no_messages,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.start_chatting_now,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context, MessageProvider provider) {
    final l10n = context.tr;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  provider.isRecording
                      ? Colors.red.shade50
                      : Colors.grey.shade50,
            ),
            child: IconButton(
              icon: Icon(
                provider.isRecording ? Icons.stop : Icons.mic,
                color: provider.isRecording ? Colors.red : Colors.grey.shade700,
                size: 24,
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
          ),
          const SizedBox(width: 4),
          Expanded(
            child: CustomTextField(
              controller: provider.messageController,
              text: l10n.type_message,
              prefixIcon: const Icon(
                Icons.emoji_emotions_outlined,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              onPressed: () {
                provider.sendMessage(registerModel);
              },
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.blue,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
