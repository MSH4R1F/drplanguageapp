import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drplanguageapp/classes/chat_message.dart';
import 'package:drplanguageapp/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:drplanguageapp/classes/chat_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Conversation extends StatefulWidget {
  final String userID;
  final String language;
  final String topic;
  final String chatLabel;
  final DocumentReference<Map<String, dynamic>> chatRef;

  const Conversation(
      {super.key,
      required this.userID,
      required this.language,
      required this.topic,
      required this.chatLabel,
      required this.chatRef});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final TextEditingController _controller = TextEditingController();
  String userID = "userID";

  // FlutterSoundRecorder? _recorder;
  // FlutterSoundPlayer? _player;
  bool _speechEnabled = false;
  bool introduced = false;
  String _lastWords = '';
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    userID = widget.userID;
    _initSpeech();
    _initializeAI();
    loadChats();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> _startListening() async {
    if (widget.language == "Arabic") {
      await _speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          setState(() {
            _lastWords = result.recognizedWords;
            _controller.text = _lastWords;
          });
        },
        localeId: 'ar_EG',
      );
    } else if (widget.language == "Urdu") {
      await _speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          setState(() {
            _lastWords = result.recognizedWords;
            _controller.text = _lastWords;
          });
        },
        localeId: 'ur_PK',
      );
    } else if (widget.language == "Bengali") {
      await _speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          setState(() {
            _lastWords = result.recognizedWords;
            _controller.text = _lastWords;
          });
        },
        localeId: 'bn_BD',
      );
    } else {
      await _speechToText.listen(
          onResult: (SpeechRecognitionResult result) {
            setState(() {
              _lastWords = result.recognizedWords;
              _controller.text = _lastWords;
            });
          },
          localeId: 'en_US');
    }
    setState(() {});
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
      if (isAi) {
        sendMessageFromAI(widget.chatRef.id, text);
        _speak(text); // Speak the AI response
      } else {
        sendMessageFromUser(userID, widget.chatRef.id, text);
      }
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
        .collection('users')
        .doc(userID)
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
    ChatService()
        .requestResponse(text, widget.language, widget.topic)
        .then((value) {
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
          mainAxisAlignment: MainAxisAlignment
              .center, // This centers the children within the Row
          children: [
            Icon(
              Icons.account_circle_rounded,
              size: 24, // Increased size for better visibility
            ),
            Expanded(
              child: Container(
                alignment: Alignment
                    .center, // This centers the text within the expanded space
                child: Text(widget.chatLabel),
              ),
            ),
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
    ChatService()
        .requestResponse(messageText, widget.language, widget.topic)
        .then((value) {
      if (value != null) {
        addtoChat(true, value);
        return value;
      }
    });
  }

  void loadChats() {
    print("loading chats");
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userID)
        .collection('chats')
        .doc(widget.chatRef.id)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((event) {
      chatt = event.docs
          .map((e) => Chat(
              sender: e.get('sender'),
              content: Text(e.get('message')),
              timestamp: e.get('timestamp').toDate(),
              ai: e.get('isAI')))
          .toList();
    });
    setState(() {});
  }

  void _initializeAI() async {
    print("Initializing AI...");
    // Fetch messages to check if AI introduction is needed
    var messagesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userID) // Ensure userID is set correctly before this call
        .collection('chats')
        .doc(widget.chatRef.id)
        .collection('messages');

    var messages = await messagesRef.get();
    print("Messages fetched: ${messages.docs.length}");

    // If no messages, send AI introduction
    if (messages.docs.isEmpty) {
      print("No messages found, sending AI introduction...");
      sendMessageToAI(
          "Pretend that you are having a conversation with the user. Your name is Jaber. Jaber is trying to help the user learn ${widget.language}. Follow these guidelines when writing your responses: 1. Communicate solely in ${widget.language}, except when asked to translate the message. 2. In your initial message, introduce yourself and your conversation topic will be ${widget.topic}. Do not divert from the topic. 3. Tailor your language complexity and speaking pace to suit a beginner in ${widget.language}, using simple vocabulary and short sentences to ensure clarity and ease of understanding. Create a natural, easygoing, back-and-forth flow to the dialogue. Summarize your response to be as brief as possible. You want to engage the user by asking questions to keep conversation going.Following this, separate your response with a % and give an improvement/advice if any to the message the user sent to help improve their language.");
    } else {
      print("Messages already exist, skipping AI introduction.");
    }
    setState(() {});
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    print(_speechEnabled);
    setState(() {});
  }

  void translateMessage(String text) {
    addtoChat(false, "Translating: $previousMessage");
    ChatService()
        .requestResponse(
            "Can you translate the text: $previousMessage to English?",
            widget.language,
            widget.topic)
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

  void _speak(String text) async {
    await _flutterTts.speak(text);
  }
}
