import 'package:flutter/material.dart';
import 'package:drplanguageapp/api/gpt.dart';

class DialoguePage extends StatefulWidget {
  const DialoguePage({super.key});

  @override
  State<DialoguePage> createState() => _DialoguePageState();
}

class _DialoguePageState extends State<DialoguePage> {
  TextGenerator generator = TextGenerator();
  String trialPrompt2 =
      "Translate the following Urdu text into English, focusing on contextual accuracy. Assess whether the highlighted word ^ should be translated independently or as an integral part of the surrounding phrase to preserve its meaning. Provide the translation of this word or phrase first, followed by the translation of the entire sentence ^. Ensure the translations are contextually coherent and present them on separate lines, with no additional text or explanations.";
  String trialPrompt1 =
      "Translate the following Urdu text into English, ensuring the translation of the word matches its context in the sentence. Provide only the English translations without including the original Urdu text. First, accurately translate the word: ^ as used in its sentence. Then, translate the full sentence: ^. Provide both translations on separate lines, with no additional text or explanations.";
  String trialPrompt3 =
      "Translate the sentence '^sentence' from Urdu to English. Then, translate the word '^filteredText', ensuring the translation is exactly how it was translated in the sentence. Please present both translations individually on separate lines, without any supplementary text or clarifications.";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    void showDialogueBox(String word, String sentence) {
      String filteredText = word.replaceAll(RegExp(r"['،؟۔!.,;:?-]"), '');
      filteredText = filteredText.replaceAll(RegExp('"'), '');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: SizedBox(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.copy), // Your icon
                        // Add more icons as needed
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: FutureBuilder(
                        future: generator.generateText(
                            "Translate the sentence '$sentence' from Urdu to English. Then, translate the word '$filteredText', ensuring the translation is exactly how it was translated in the sentence. Please present both translations individually on separate lines, without any additional text, clarifications or introductions."),
                        builder: (BuildContext context,
                            AsyncSnapshot<String?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              List<String> translations =
                                  snapshot.data!.split('\n');
                              String word =
                                  translations[translations.length - 1]
                                      .replaceAll(RegExp(r"[^A-Za-z ]"), '');
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SelectableText(filteredText),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(word.toLowerCase()),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(),
                                      SelectableText(
                                        sentence,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        translations[0]
                                            .replaceAll(RegExp(r"-"), ''),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            }
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    List<Widget> splitSelectableWord(String sentence) {
      List<String> splitText = sentence.split(RegExp(r' '));
      return splitText
          .map(
            (word) => InkWell(
              onTap: () => showDialogueBox(word, sentence),
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
      List<String> splitText = text.split(RegExp(r'(?<=[۔.])\s*'));
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
        title: const Text("Comprehension"),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            onPressed: () async {
              generator.regenerateText(
                  "Give a paragraph of about 200 words in Urdu without any additional text or introduction");
              Navigator.pushReplacementNamed(context, '/dashboard/readingcomp');
            },
            icon: const Icon(Icons.refresh),
          ),
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
        future: generator.getText(
            "Give a paragraph of about 200 words in Urdu without any additional text or introduction"),
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
