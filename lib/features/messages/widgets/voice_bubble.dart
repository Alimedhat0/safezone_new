import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/messages/logic/message_provider.dart';

class VoiceBubble extends StatelessWidget {
  final String audioUrl;
  final bool isSender;

  const VoiceBubble({
    super.key,
    required this.audioUrl,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageProvider>(
      builder: (context, provider, _) {
        final isCurrent = provider.currentPlayingUrl == audioUrl;
        return Row(
          children: [
            IconButton(
              icon: Icon(
                provider.isPlaying && isCurrent
                    ? Icons.pause
                    : Icons.play_arrow,
                color: isSender ? Colors.white : Colors.black,
              ),
              onPressed: () {
                provider.playVoice(audioUrl);
              },
            ),

            Expanded(
              child: Slider(
                value: isCurrent ? provider.position.inSeconds.toDouble() : 0,
                max:
                    isCurrent
                        ? (provider.duration.inSeconds == 0
                            ? 1
                            : provider.duration.inSeconds.toDouble())
                        : 1,
                onChanged: (_) {},
              ),
            ),

            Text(
              provider.formatDuration(provider.duration),
              style: TextStyle(
                color: isSender ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        );
      },
    );
  }
}
