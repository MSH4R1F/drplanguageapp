import 'dart:ffi';
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

const List<String> list = <String>["Al Minshawi", "Khalil Al-Qari", "GENERIC_BANGLADESHI_NAME"];

class _ConversationState extends State<Conversation> {
  final TextEditingController _controller = TextEditingController();
  final String chatID = "chat1";
  String userID = "userID";
  var dropdownValue = list.first; 

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
    _initializeAI();
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
      // chatt.insert(0, Chat(sender: "me", content: Text("saved to $_filePath"), timestamp: DateTime.now(), ai: false));
      chatt.insert(0, Chat(sender: "me", content: const Text("--- AUDIO SENT ---"), timestamp: DateTime.now(), ai: false));

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


  // declare list of chats
  List<Chat> chatt = [];

  void addtoChat(bool isAi, String text) {
    Chat toAdd =
        Chat(sender: "Me", content: text, timestamp: DateTime.now(), ai: isAi);
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
    ChatService().request(text).then((value) {
      if (value != null) {
        addtoChat(true, value);
      }
    });
    _controller.clear();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.account_circle_rounded, size: 50,),
            Container(
              margin: const EdgeInsets.all(5.0),
            ),
            Expanded(
              child: DropdownMenu<String>(
                    initialSelection: list.first,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(value: value, label: value);
                    }).toList(),
                ),
            )
          ],
        ),
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
                    onPressed: (() => {
                      if (!_isRecording) {
                      userPressedSend(_controller.text)
                      }
                    }),
                    icon: Icon(
                      Icons.send,
                      size: 30,
                      color: _isRecording ? Colors.grey : Theme.of(context).primaryColor,
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
                    icon: Icon(_isRecording ? Icons.stop : Icons.mic,
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

  void sendMessageToAI(String messageText) {
    ChatService().request(messageText).then((value) {
      if (value != null) {
        addtoChat(true, value);
        return value;
      }
    });
  }

  void _initializeAI() {
    sendMessageToAI(
        "Hello! Following this message you are going to help this user practise conversation in Arabic. Here are the rules you must follow: 1: Speak only in Arabic, 2: Do not speak English except when I ask for someone help. First message introduce yourself, your name is Jaber, the topic you will speak about today is 'The Weather'. Please can you speak like you are speaking to a beginner in the language.");
  }
}
