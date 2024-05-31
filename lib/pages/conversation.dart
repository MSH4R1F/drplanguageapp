
import 'package:drplanguageapp/pages/chat_page.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  const Conversation({super.key});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {

  final TextEditingController _controller = TextEditingController();
  // final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  // bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    // _initialiseRecorder();
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
    Chat(sender: "Bob", content: "Hello boy", timestamp: DateTime.parse("2012-02-27 13:27:00"), colour: Colors.green, ai: true),
    Chat(sender: "Jaffer", content: "stiunkty stinky", timestamp: DateTime.parse("2012-02-27 13:28:00") , colour: Colors.blue, ai: false),
    Chat(sender: "Bob", content: "Hello boy", timestamp: DateTime.parse("2012-02-27 13:27:00"), colour: Colors.green, ai: true),
    Chat(sender: "Jaffer", content: "stiunkty stinky", timestamp: DateTime.parse("2012-02-27 13:28:00") , colour: Colors.blue, ai: false),
    Chat(sender: "Bob", content: "Hello boy", timestamp: DateTime.parse("2012-02-27 13:27:00"), colour: Colors.green, ai: true),
    Chat(sender: "Jaffer", content: "stiunkty stinky", timestamp: DateTime.parse("2012-02-27 13:28:00") , colour: Colors.blue, ai: false),
    Chat(sender: "Bob", content: "Hello boy", timestamp: DateTime.parse("2012-02-27 13:27:00"), colour: Colors.green, ai: true),
    Chat(sender: "Jaffer", content: "stiunkty stinky", timestamp: DateTime.parse("2012-02-27 13:28:00") , colour: Colors.blue, ai: false),
    Chat(sender: "Bob", content: "Hello boy", timestamp: DateTime.parse("2012-02-27 13:27:00"), colour: Colors.green, ai: true),
    Chat(sender: "Jaffer", content: "stiunkty stinky", timestamp: DateTime.parse("2012-02-27 13:28:00") , colour: Colors.blue, ai: false),
    Chat(sender: "Bob", content: "Hello boy", timestamp: DateTime.parse("2012-02-27 13:27:00"), colour: Colors.green, ai: true),
    Chat(sender: "Jaffer", content: "stiunkty stinky", timestamp: DateTime.parse("2012-02-27 13:28:00") , colour: Colors.blue, ai: false),
    Chat(sender: "Bob", content: "Hello boy", timestamp: DateTime.parse("2012-02-27 13:27:00"), colour: Colors.green, ai: true),
    Chat(sender: "Jaffer", content: "stiunkty stinky", timestamp: DateTime.parse("2012-02-27 13:28:00") , colour: Colors.blue, ai: false),
    Chat(sender: "Bob", content: "Hello boy", timestamp: DateTime.parse("2012-02-27 13:27:00"), colour: Colors.green, ai: true),
    Chat(sender: "Jaffer", content: "stiunkty stinky", timestamp: DateTime.parse("2012-02-27 13:28:00") , colour: Colors.blue, ai: false),
    Chat(sender: "Bob", content: "Hello boy", timestamp: DateTime.parse("2012-02-27 13:27:00"), colour: Colors.green, ai: true),
    Chat(sender: "Jaffer", content: "stihjtyjfgjfgjtyjhsthhjshghdhdfhfghdfhsfhdfhunkty stinky", timestamp: DateTime.parse("2012-02-27 13:28:00") , colour: Colors.blue, ai: false)
    ];

  void addtoChat() {
    var temp = _controller.text;
    _controller.clear();
    setState(() {
      chatt = [Chat(sender: "Me", content: temp, timestamp: DateTime.now(), colour: Colors.blue, ai: false)];
    });
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
                          hintStyle: TextStyle(
                            fontSize: 15.0
                          )
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: addtoChat,
                      icon: Icon(
                        Icons.send,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    IconButton(
                      // TODO: MAKE MICROPHONE WORK
                      onPressed: printInput,
                      icon: Icon(
                        Icons.mic,
                        size: 30,
                        color: Theme.of(context).primaryColor
                      ),
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