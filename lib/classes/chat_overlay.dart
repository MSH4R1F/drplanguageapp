import 'package:drplanguageapp/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Overlay should have:

// if its ai then have Overlay and a button to play the audio
// else have feedback on your response and a button to play audio

class ChatOverlay extends StatelessWidget {
  final bool ai;

  final String chatText;
  final Chat chat;
  final FlutterTts _flutterTts = FlutterTts();
  ChatOverlay(
      {super.key,
      required this.ai,
      required this.chatText,
      required this.chat});

  @override
  Widget build(BuildContext context) {
    print("Building Chat Overlay");
    print("AI: $ai");
    print("Chat Text: $chatText");

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
          Text(chat.content.data!, style: const TextStyle(fontSize: 20)),
          Container(
            height: 50,
          ),
          GestureDetector(
            // TODO PLAY AUDIO FROM THIS BUTTON
            onTap: () {
              print("Chat stuff: ${chat.content.data!}");
              _speak(chat.content.data!);
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
              child: Text(
            chat.ai ? "Suggested Response" : "Feedback",
            style: const TextStyle(fontSize: 25),
          )),
          Container(
            child: Text(
              chat.suggestion,
              style: TextStyle(fontSize: 20),
            ),
          )
        ]));
  }

  void _speak(String text) async {
    await _flutterTts.speak(text);
  }
}
