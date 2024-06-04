import 'package:flutter/material.dart';

class _CombinedChat extends StatefulWidget {
  final Combined combined;
  const _CombinedChat({
    super.key,
    required this.combined
    });

  @override
  State<_CombinedChat> createState() => __CombinedChatState();
}

class __CombinedChatState extends State<_CombinedChat> {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}

class Combined {
  final String sender;
  final Widget text;
  final Widget audio;
  final DateTime timestamp;
  final bool ai;


  Combined({
    required this.sender,
    required this.text,
    required this.audio,
    required this.timestamp,
    required this.ai,
  });

  @override
  String toString() {
    return 'CHAT MESSAGE BY \n sender: $sender \n COMBINED MESSAGE \n timestamp: ${timestamp.toString()} \n AI?: $ai ';
  }

}