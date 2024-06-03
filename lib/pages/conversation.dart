import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drplanguageapp/pages/chat_page.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  final String userID;
  Conversation({super.key, required this.userID});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final TextEditingController _controller = TextEditingController();
  // final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  // bool _isRecording = false;
  final String chatID = "chat1";
  String userID = "userID";
  @override
  void initState() {
    super.initState();
    // _initialiseRecorder();
    userID = widget.userID;
  }

  // Future<void> _initialiseRecorder() async {
  //   await _recorder.openRecorder();

  //   if (await Permission.microphone.request().isGranted) {
  //     print("yayy");
  //   } else {
  //     // TODO: GREY OUT MIC IF MIC PERMISSION NOT ALLOWED
  //     print("Denied");
  //   }
  // }

  // Future<void> _initialiseRecorder() async {
  //   await _recorder.openRecorder();
  //   var status = await Permission.microphone.request();
  //   // if (!status.isGranted) {
  //   //   throw RecordingPermissionException("Microphone permission not granted");
  //   // }
  // }

  @override
  void dispose() {
    // _recorder.closeRecorder();
    _controller.dispose();
    super.dispose();
  }

  void printInput() {
    print("User input: ${_controller.text}");
    _controller.clear();
  }

  // void _micButtonPressed() async {
  //   if (!_isRecording) {
  //     // start recording
  //     await _recorder.startRecorder(
  //       toFile: 'current_recording.aac',
  //       codec: Codec.aacADTS,
  //     );

  //     setState(() {
  //       _isRecording = true;
  //     });
  //   } else {
  //     String path = (await _recorder.stopRecorder()).toString();
  //     setState(() {
  //       _isRecording = false;
  //     });
  //     print("Recorded audio path: $path");
  //   }
  // }

  var chatt = [
    Chat(
        sender: "AI",
        content: "Hello! How can I help you today?",
        timestamp: DateTime.now(),
        colour: Colors.green,
        ai: true),
  ];

  void addtoChat(bool isAi, String text) {
    Chat toAdd = Chat(
        sender: "Me",
        content: text,
        timestamp: DateTime.now(),
        colour: Colors.blue,
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
                    onPressed: printInput,
                    icon: Icon(Icons.mic,
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
