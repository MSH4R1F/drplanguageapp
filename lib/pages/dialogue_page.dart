import 'package:flutter/material.dart';
import 'package:drplanguageapp/api/gpt.dart';

class DialoguePage extends StatefulWidget {
  const DialoguePage({super.key});

  @override
  State<DialoguePage> createState() => _DialoguePageState();
}

class _DialoguePageState extends State<DialoguePage> {
  TextGenerator generator = TextGenerator();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    void showDialogueBox(String text) {
      String filteredText = text.replaceAll(RegExp(r"['،؟۔!.,;:?-]"), '');
      filteredText = filteredText.replaceAll(RegExp('"'), '');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  filteredText,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
        },
      );
    }

    List<Widget> splitSelectableWord(String text) {
      List<String> splitText = text.split(RegExp(r' '));
      return splitText
          .map(
            (word) => InkWell(
              onTap: () => showDialogueBox(word),
              child: Text(
                "$word ",
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
          .toList();
    }

    List<Widget> splitSentence(String text) {
      List<String> splitText = text.split(RegExp(r'(?<=[۔])\s*'));
      return splitText
          .map(
            (sentence) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: splitSelectableWord(sentence),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
              ],
            ),
          )
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Dialogue"),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/loginpage');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.lime,
        child: Column(
          children: [
            const DrawerHeader(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/bloom.png'),
                radius: 50,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble),
              title: const Text("Conversation"),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard/conversation');
              },
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb),
              title: const Text("Highlights"),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard/highlights');
              },
            ),
            ListTile(
              leading: const Icon(Icons.subtitles),
              title: const Text("Flashcards"),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard/flashcards');
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<String?>(
        future: generator.generateText(
            "Give a paragraph of about 100 words in Urdu without any additional text or introduction"),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: splitSentence(snapshot.data!),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
