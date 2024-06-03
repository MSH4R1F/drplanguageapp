
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final List<Chat> chats;
  const ChatPage({super.key, required this.chats});

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
                alignment: widget.chats[index].ai ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: widget.chats[index].ai ? Colors.grey[300] : Colors.green[300],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12.0),
                    topRight: const Radius.circular(12.0),
                    bottomRight: widget.chats[index].ai ? const Radius.circular(12.0) : Radius.zero,
                    bottomLeft: widget.chats[index].ai ? Radius.zero :  const Radius.circular(12.0),
                  ),
                ),
                child: Text(
                  widget.chats[index].content,
                  style: const TextStyle(
                    color: Colors.black,
                  )
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
  final String content;
  final DateTime timestamp;
  final Color colour;
  final bool ai;

  Chat({
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.colour,
    required this.ai,
  });

  @override
  String toString() {
    return 'CHAT MESSAGE BY \n sender: $sender \n content: $content \n timestamp: ${timestamp.toString()} \n AI?: $ai ';
  }

}