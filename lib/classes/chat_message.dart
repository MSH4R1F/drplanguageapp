import 'package:drplanguageapp/pages/chat_page.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final Chat chat;
  const ChatMessage({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),
      child: const Text(
        "hello stinksdfgo[dngoisfjh[oisfjh]]",
        style:  TextStyle(fontSize: 16)
        ,)
      ,
      ); 
  }
}