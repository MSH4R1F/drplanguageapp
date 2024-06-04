import 'package:drplanguageapp/pages/chat_page.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final Chat chat;
  const ChatMessage({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: chat.ai ? Colors.grey[300] : Colors.green[300],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12.0),
                    topRight: const Radius.circular(12.0),
                    bottomRight: chat.ai ? const Radius.circular(12.0) : Radius.zero,
                    bottomLeft: chat.ai ? Radius.zero :  const Radius.circular(12.0),
                  ),
                ),
                child: Text(
                  chat.content,
                  style: const TextStyle(
                    color: Colors.black,
                  )
                ),
                );
  }
}

// content is either text or audio