
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
    return ListView.builder(
      reverse: true,
      itemCount: widget.chats.length,
      prototypeItem: ListTile(
        title: Text(widget.chats.first.toString()),
      ),
      itemBuilder: (context, index) {
        return Container(
                constraints: const BoxConstraints(maxWidth: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        widget.chats[index].toString(),
                        textAlign: widget.chats[index].ai ? TextAlign.left : TextAlign.right
                        ),
                        tileColor: widget.chats[index].ai ? Colors.red : Colors.blue,
                    )
                  ],
                ),
              );
      },
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