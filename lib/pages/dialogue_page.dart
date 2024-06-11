import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drplanguageapp/pages/flashcard_store.dart';
import 'package:flutter/material.dart';
import 'package:drplanguageapp/api/gpt.dart';

class DialoguePage extends StatefulWidget {
  final String userID;
  const DialoguePage({super.key, required this.userID});

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
    void showFlashcardDialogue(BuildContext context, FlashcardStore store) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text("Add to flashcards?"),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actionsPadding: const EdgeInsets.all(8),
              actions: [
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    var collection = FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.userID)
                        .collection('flashcards');
                    try {
                      await collection.add({
                        'word': store.word,
                        'sentence': store.sentence,
                        'trWord': store.trWord,
                        'trSentence': store.trSentence
                      });
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      print("Error adding data: $e");
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: const Text("Yes"),
                ),
              ],
            );
          });
    }

    void showDialogueBox(String word, String sentence) {
      String filteredWord = word.replaceAll(RegExp(r"['،؟۔!.,;:?-]"), '');
      filteredWord = filteredWord.replaceAll(RegExp('"'), '');

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
              child: FutureBuilder(
                future: generator.generateText(
                    "Translate the sentence '$sentence' from Urdu to English. Then, translate the word '$filteredWord', ensuring the translation is exactly how it was translated in the sentence. Please present both translations individually on separate lines, without any additional text, clarifications or introductions."),
                builder:
                    (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<String> translations = snapshot.data!.split('\n');
                      String trSentence =
                          translations[0].replaceAll(RegExp(r"-"), '');
                      String word = translations[translations.length - 1]
                          .replaceAll(RegExp(r"[^A-Za-z ]"), '');
                      FlashcardStore store = FlashcardStore(
                          word: filteredWord,
                          trWord: word,
                          sentence: sentence,
                          trSentence: trSentence);
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () =>
                                      showFlashcardDialogue(context, store),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SelectableText(filteredWord),
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
                                        trSentence,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/loginpage',
                (Route<dynamic> route) => false,
              );
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
