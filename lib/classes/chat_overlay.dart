import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Overlay should have:

// if its ai then have Overlay and a button to play the audio
// else have feedback on your response and a button to play audio

class ChatOverlay extends StatelessWidget {
  final bool ai;

  final String chatText;
  final List<String>? responses;
  final String? feedback;
  final FlutterTts _flutterTts = FlutterTts();
  ChatOverlay(
      {super.key,
      required this.ai,
      required this.chatText,
      this.responses,
      this.feedback});

  @override
  Widget build(BuildContext context) {
    print("Building Chat Overlay");
    print("AI: $ai");
    print("Chat Text: $chatText");
    print("Responses: $responses");
    print("Feedback: $feedback");
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: [
        Text("Message Content",
            style: const TextStyle(
              fontSize: 25,
            )),
        Container(
          height: 50,
        ),
        Text(chatText, style: const TextStyle(fontSize: 20)),
        Container(
          height: 50,
        ),
        GestureDetector(
          // TODO PLAY AUDIO FROM THIS BUTTON
          onTap: () {
            _speak(chatText);
          },
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Theme.of(context).focusColor),
            child: const Icon(
              Icons.play_arrow,
              size: 50,
            ),
          ),
        ),
        Container(
          height: 100,
        ),
        Text(
            responses != null && responses!.isEmpty && feedback != null
                ? "Feedback: ${responses![0]}"
                : "No feedback given",
            style: const TextStyle(
              fontSize: 25,
            )),
      ]),
    );
  }

  void _speak(String text) async {
    await _flutterTts.speak(text);
  }
}
