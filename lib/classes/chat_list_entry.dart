import 'package:cloud_firestore/cloud_firestore.dart';
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
      constraints:
          const BoxConstraints(maxHeight: 100), // Max height is set to 100
      padding: const EdgeInsets.symmetric(
          horizontal: 10), // Padding added for spacing
      child: Row(
        children: [
          ClipOval(
            child: SizedBox(
              width: 60, // Reduced to fit within the height constraint
              height: 60, // Same as width for a circular image
              child: widget.chatEntry.image, // Display the chat entry image
            ),
          ),
          SizedBox(width: 10), // Provides a gap between the image and text
          Expanded(
            // Ensures that the text does not overflow
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatEntry.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow
                      .ellipsis, // Prevents overflow by showing ellipsis
                ),
                Text(
                  widget.chatEntry.lastmessage,
                  style: const TextStyle(color: Colors.grey, fontSize: 10.0),
                  overflow: TextOverflow.ellipsis, // Same as above
                ),
              ],
            ),
          ),
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
  DocumentReference<Map<String, dynamic>>? reference;

  ChatEntry(this.image, this.title, this.lastmessage, this.selection);
  ChatEntry.withReference(
      this.image, this.title, this.lastmessage, this.selection, this.reference);

  void setReference(DocumentReference<Map<String, dynamic>> ref) {
    reference = ref;
  }

  getReference() {
    return reference;
  }
}
