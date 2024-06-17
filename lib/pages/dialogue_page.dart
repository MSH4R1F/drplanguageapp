import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drplanguageapp/classes/chat_service.dart';
import 'package:drplanguageapp/main.dart';
import 'package:drplanguageapp/pages/flashcard_store.dart';
import 'package:drplanguageapp/pages/languages.dart';
import 'package:drplanguageapp/pages/selection_page.dart';
import 'package:flutter/material.dart';
import 'package:drplanguageapp/api/gpt.dart';

class DialoguePage extends StatefulWidget {
  final String userID;
  final String language;
  final String difficulty;
  const DialoguePage(
      {super.key,
      required this.userID,
      required this.language,
      required this.difficulty});

  @override
  State<DialoguePage> createState() => _DialoguePageState();
}

class _DialoguePageState extends State<DialoguePage> {
  late TextGenerator generator;
  Langauge langStore = Langauge();

  @override
  void initState() {
    super.initState();
    generator = TextGenerator(
        userID: widget.userID,
        language: widget.language,
        difficulty: widget.difficulty);
  }

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
                        .collection('flashcards')
                        .doc('language')
                        .collection(widget.language);
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
      ChatService gpt = ChatService();
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
                future: gpt.request(
                    "Translate the sentence '$sentence' from ${widget.language} to English. Then, translate the word '$filteredWord', ensuring the translation is exactly how it was translated in the sentence. Please present both translations individually on separate lines, without any additional text, clarifications or introductions."),
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
                                  icon: const Icon(Icons.volume_up),
                                  onPressed: () async {
                                    await speak(
                                        filteredWord,
                                        langStore
                                            .getSpeechCode(widget.language));
                                  },
                                ),
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
      List<String> splitText = text.split(RegExp(r'(?<=[۔.।])\s*'));
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
            onPressed: () {
              setState(() {
                generator.regenerateText();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SelectionPage(
                      userID: widget.userID,
                      language: widget.language,
                      difficulty: widget.difficulty),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_rounded),
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
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/loginpage', (Route<dynamic> route) => false);
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      body: FutureBuilder<String?>(
        future: generator.getText(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Directionality(
                  textDirection: langStore.getTextDirection(widget.language),
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
