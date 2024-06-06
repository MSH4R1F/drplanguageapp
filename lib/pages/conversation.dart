import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drplanguageapp/classes/chat_message.dart';
import 'package:drplanguageapp/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:drplanguageapp/classes/chat_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Conversation extends StatefulWidget {
  final String userID;
  final String language;
  final String topic;
  final String chatLabel;

  const Conversation(
      {super.key,
      required this.userID,
      required this.language,
      required this.topic,
      required this.chatLabel});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final TextEditingController _controller = TextEditingController();
  final String chatID = "chat1";
  String userID = "userID";

  // FlutterSoundRecorder? _recorder;
  // FlutterSoundPlayer? _player;
  bool _speechEnabled = false;
  String _lastWords = '';
  final SpeechToText _speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initializeAI();
    userID = widget.userID;
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> _startListening() async {
    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        setState(() {
          _lastWords = result.recognizedWords;
          _controller.text = _lastWords;
        });
      },
      localeId: 'ar_EG',
    );
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  // declare list of chats
  List<Chat> chatt = [];
  var suggestions = [
    "What do you mean?",
    "Translate to English",
    "End Conversation",
  ];
  var previousMessage = "";
  void addtoChat(bool isAi, String text) {
    Chat toAdd = Chat(
        sender: "Me", content: Text(text), timestamp: DateTime.now(), ai: isAi);
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
      previousMessage = value!;
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.account_circle_rounded,
              size: 15,
            ),
            const Spacer(),
            Text(widget.chatLabel),
            const Spacer(flex: 3)
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: ChatPage(
            chats: chatt,
            textToSpeechEngine: "",
          )),
          Divider(),
          SizedBox(
            height: 50,
            child: ListView(
                scrollDirection: Axis.horizontal,
                // children: [TextButton(onPressed: () {}, child: Text("Ballsfggdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd"),)],
                children: suggestions
                    .map(
                        // TODO: This on pressed can change so that it plays the text out loud, so the user has to say it
                        (str) => GestureDetector(
                            onTap: () {
                              if (str == "End Conversation") {
                                Navigator.pop(context);
                              } else if (str == "Translate to English") {
                                translateMessage(
                                    "Translate your previous message to English");
                              } else {
                                explanationRequired();
                              }
                            },
                            onLongPress:
                                () {}, // TODO: MAKE SUGGESTION PLAY OUT LOUD
                            child: ChatMessage(
                              chat: Chat(
                                  sender: "Me",
                                  content: Text(str),
                                  timestamp: DateTime.now(),
                                  ai: false),
                            )))
                    .toList()),
          ),
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
                          if (_speechToText.isNotListening)
                            {userPressedSend(_controller.text)}
                        }),
                    icon: Icon(
                      Icons.send,
                      size: 30,
                      color: _speechToText.isListening
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_speechToText.isListening) {
                        _stopListening();
                      } else {
                        _startListening();
                      }
                    },
                    icon: Icon(
                        _speechToText.isListening ? Icons.stop : Icons.mic,
                        size: 30,
                        color: Theme.of(context).primaryColor),
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
        "Hello! In the following conversation, you will help this user practice speaking Arabic. Please adhere to these rules: 1. Communicate solely in Arabic, except when explicitly requested to provide assistance in English. 2. Your name is Jaber. In your initial message, introduce yourself and mention that the topic of today's conversation will be ${widget.topic} . 3. Tailor your language complexity and speaking pace to suit a beginner in Arabic, using simple vocabulary and short sentences to ensure clarity and ease of understanding");
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    print(_speechEnabled);
    setState(() {});
  }

  void translateMessage(String text) {
    addtoChat(false, "Translating: $previousMessage");
    ChatService()
        .request("Can you translate the text: $previousMessage to English?")
        .then((value) {
      if (value != null) {
        addtoChat(true, value);
      }
    });
    _controller.clear();
  }

  void explanationRequired() {
    addtoChat(false, "Can you explain what you said?");
    ChatService()
        .request(
            "Can you explain the text: $previousMessage only in ${widget.language}")
        .then((value) {
      if (value != null) {
        addtoChat(true, value);
      }
    });
    _controller.clear();
  }
}
