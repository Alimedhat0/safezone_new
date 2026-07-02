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
        final isPlaying = provider.isPlaying && isCurrent;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isSender
                        ? Colors.white.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
              ),
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: isSender ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  provider.playVoice(audioUrl);
                },
              ),
            ),
            const SizedBox(width: 8),

            Expanded(
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3.0,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6.0,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 12.0,
                      ),
                      activeTrackColor:
                          isSender ? Colors.white : Colors.blue.shade600,
                      inactiveTrackColor:
                          isSender
                              ? Colors.white.withOpacity(0.3)
                              : Colors.grey.shade300,
                      thumbColor:
                          isSender ? Colors.white : Colors.blue.shade600,
                      overlayColor: (isSender
                              ? Colors.white
                              : Colors.blue.shade600)
                          .withOpacity(0.2),
                    ),
                    child: Slider(
                      value:
                          isCurrent
                              ? provider.position.inSeconds.toDouble()
                              : 0,
                      max:
                          isCurrent
                              ? (provider.duration.inSeconds == 0
                                  ? 1
                                  : provider.duration.inSeconds.toDouble())
                              : 1,
                      onChanged: (_) {},
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      provider.formatDuration(provider.duration),
                      style: TextStyle(
                        color:
                            isSender
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey.shade600,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
