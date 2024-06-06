import 'package:drplanguageapp/classes/new_chat_form.dart';
import 'package:flutter/material.dart';

class ChatListEntry extends StatefulWidget {
  
  final ChatEntry chatEntry;
  const ChatListEntry({super.key, required this.chatEntry});

  @override
  State<ChatListEntry> createState() => _ChatListEntryState();
}

class _ChatListEntryState extends State<ChatListEntry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Spacer(),
          ClipOval(
            child: SizedBox(
              width: 200,
              height: 200,
              child: widget.chatEntry.image),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.chatEntry.title, style: const TextStyle(fontWeight: FontWeight.bold),),
              Text(widget.chatEntry.lastmessage, style: const TextStyle(color: Colors.grey, fontSize: 10.0),)
              ],
          ),
          const Spacer(flex: 5,),
        ],
      ),
    );
  }
}


class ChatEntry {
  final String title;
  final String lastmessage;
  final Image image;
  final Selection selection;

  ChatEntry(this.image, this.title, this.lastmessage, this.selection);
}