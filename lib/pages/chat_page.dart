
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
        return Row(
          children: [
            widget.chats[index].ai ? const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage("https://media.newyorker.com/photos/59095bb86552fa0be682d9d0/master/pass/Monkey-Selfie.jpg"),
                ) : const SizedBox(width: 0, height: 0,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 300),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        widget.chats[index].toString(),
                        textAlign: widget.chats[index].ai ? TextAlign.left : TextAlign.right
                        ),
                        tileColor: widget.chats[index].ai ? Theme.of(context).primaryColorLight : Theme.of(context).secondaryHeaderColor,
                    ), Text(
                      widget.chats[index].timestamp.toLocal().toString(),
                      style: const TextStyle(fontSize: 0.5),
                      )
                  ],
                ),
              ),
            ),
            !widget.chats[index].ai ? const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage("https://www.newarab.com/sites/default/files/styles/large_16_9/public/2023-08/GettyImages-1258930731.jpg?h=e7c891e8&itok=9UVWR3Nt"),
                ) : const SizedBox(width: 0, height: 0,),
          ],
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