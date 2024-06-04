import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drplanguageapp/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:drplanguageapp/classes/chat_service.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Conversation extends StatefulWidget {
  final String userID;
  const Conversation({super.key, required this.userID});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final TextEditingController _controller = TextEditingController();
  final String chatID = "chat1";
  String userID = "userID";

  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  // bool _isPlaying = false;
  String? _filePath;



  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _initializeRecorder();
    _initializePlayer();
    userID = widget.userID;
  }

  Future<void> _initializeRecorder() async {
    await _recorder!.openRecorder();
    await _requestPermissions();
  }

  Future<void> _initializePlayer() async {
    await _player!.openPlayer();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _player!.closePlayer();
    _recorder = null;
    _player = null;
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    String path = '${docsDir.path}/voice_recording.aac';
    await _recorder!.startRecorder(
      toFile: path,
      codec: Codec.aacADTS,
    );
    setState(() {
      _isRecording = true;
      _filePath = path;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
      chatt.insert(0, Chat(sender: "me", content: "saved to $_filePath/voice_recording.aac", timestamp: DateTime.now(), ai: false));
    });
  }

  // Future<void> _startPlayback() async {
  //   if (_filePath != null) {
  //     await _player!.startPlayer(
  //       fromURI: _filePath,
  //       codec: Codec.aacADTS,
  //       whenFinished: () {
  //         setState(() {
  //           _isPlaying = false;
  //         });
  //       },
  //     );
  //     setState(() {
  //       _isPlaying = true;
  //     });
  //   }
  // }

  // Future<void> _stopPlayback() async {
  //   await _player!.stopPlayer();
  //   setState(() {
  //     _isPlaying = false;
  //   });
  // }



  var chatt = [
    Chat(
        sender: "AI",
        content: "Hello! How can I help you today?",
        timestamp: DateTime.now(),
        ai: true),
  ];

  void addtoChat(bool isAi, String text) {
    Chat toAdd = Chat(
        sender: "Me",
        content: text,
        timestamp: DateTime.now(),
        ai: isAi);
    setState(() {
      chatt.insert(0, toAdd);
      sendMessageFromUser(userID, chatID, text);
    });
  }

  Future<String> fetchUserNameByUID(String userUID) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('userUID', isEqualTo: userUID)
        .get();

    // log the querySnapshot using a logging framework but print in red
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.get('Name');
    } else {
      return 'User not found';
    }
  }

  void sendMessageFromUser(String userID, String chatId, String messageText) {
    var messagesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('chats')
        .doc(chatId)
        .collection('messages');
    // get name from userID, fetchUserNameByUID returns a future
    fetchUserNameByUID(userID).then((name) {
      messagesRef.add({
        'sender': name,
        'message': messageText,
        'timestamp': DateTime.now(),
        'isAI': false
      }).then((docRef) {
        print('Message sent');
      }).catchError((error) {
        print('Error sending message: $error');
      });
    });
  }

  void sendMessageFromAI(String chatID, String messageText) {
    var messagesRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatID)
        .collection('messages');
    messagesRef.add({
      'sender': 'AI',
      'message': messageText,
      'timestamp': DateTime.now(),
      'isAI': true
    }).then((docRef) {
      print('Message sent');
    }).catchError((error) {
      print('Error sending message: $error');
    });
  }

  void userPressedSend(String text) {
    if (text.isNotEmpty) {
      addtoChat(false, text);
    }
    ChatService().request().then((value) {
      if (value != null) {
        addtoChat(true, value);
        addtoChat(false, "bye");
      }
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversation"),
      ),
      body: Column(
        children: [
          Expanded(child: ChatPage(chats: chatt)),
          Container(
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Reply here or with the mic",
                          hintStyle: TextStyle(fontSize: 15.0)),
                    ),
                  ),
                  IconButton(
                    onPressed: (() => userPressedSend(_controller.text)),
                    icon: Icon(
                      Icons.send,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  IconButton(
                    // TODO: MAKE MICROPHONE WORK
                    onPressed: () {
                      if (_isRecording) {
                        _stopRecording();
                      } else {
                        _startRecording();
                      }
                    },
                    icon: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                        size: 30, color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
