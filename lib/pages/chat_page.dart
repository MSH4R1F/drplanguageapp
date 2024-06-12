import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final Object textToSpeechEngine;
  final List<Chat> chats;
  final Function(String, String) overlayFunction;
  const ChatPage(
      {super.key,
      required this.chats,
      required this.textToSpeechEngine,
      required this.overlayFunction});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: widget.chats.length,
            itemBuilder: (context, index) {
              return Align(
                alignment: widget.chats[index].ai
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                // child: ChatMessage(chat: widget.chats[index]),
                child: GestureDetector(
                  onDoubleTap: () {
                    // TODO: ADD TTS FUNCTIONALITY
                    // widget.textToSpeechEngine
                    // widget.chats[index].content.data has the string to output
                  },
                  child: GestureDetector(
                    // TODO: ADD TTS ON DOUBLE TAP
                    onDoubleTap: () => {print("DOUBLE TAPPED")},
                    onLongPress: () {
                      widget.overlayFunction(
                          widget.chats[index].content.data!,
                          widget.chats[index].ai
                              ? widget.chats[index].content.data!.split("%")[1]
                              : widget.chats[index].content.data!
                                  .split("%")[2]);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: widget.chats[index].ai
                            ? Colors.grey[300]
                            : Colors.green[300],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12.0),
                          topRight: const Radius.circular(12.0),
                          bottomRight: widget.chats[index].ai
                              ? const Radius.circular(12.0)
                              : Radius.zero,
                          bottomLeft: widget.chats[index].ai
                              ? Radius.zero
                              : const Radius.circular(12.0),
                        ),
                      ),
                      child: widget.chats[index].content,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Chat {
  final String sender;
  final Text content;
  final DateTime timestamp;
  final bool ai;

  Chat({
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.ai,
  });

  @override
  String toString() {
    return 'CHAT MESSAGE BY \n sender: $sender \n content: $content \n timestamp: ${timestamp.toString()} \n AI?: $ai ';
  }
}
