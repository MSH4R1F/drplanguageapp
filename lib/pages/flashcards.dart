import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drplanguageapp/main.dart';
import 'package:flutter/material.dart';

class Flashcard {
  final String word;
  final String translation;
  final String sentence;
  final String translatedSentence;
  final String definition;
  final List<String> synonyms;
  final String imageUrl;
  final String imgSource;
  final String hint;

  Flashcard({
    required this.word,
    required this.translation,
    required this.sentence,
    required this.translatedSentence,
    required this.definition,
    required this.synonyms,
    required this.imageUrl,
    required this.imgSource,
    required this.hint,
  });
}

Future<List<Flashcard>> getFlashcards(String userID) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('flashcards')
        .get();
    return querySnapshot.docs.map((doc) {
      return Flashcard(
        word: doc['word'],
        translation: doc['trWord'],
        sentence: doc['sentence'],
        translatedSentence: doc['trSentence'],
        definition: '*there is nothing here yet!*',
        // synonyms: List<String>.from(doc['synonyms']),
        synonyms: [],
        imageUrl:
            'https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/04/03/17/donald-trump-sisi.jpg?width=1200',
        imgSource: 'the Independent',
        hint: 'You have not added a hint yet!',
      );
    }).toList();
  } catch (e) {
    print('Error fetching flashcards: $e');
    return [];
  }
}

class WordsListPage extends StatelessWidget {
  final String userID;
  final Future<List<Flashcard>> flashcards;

  WordsListPage({super.key, required this.userID})
      : flashcards = getFlashcards(userID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Flashcards'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
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
              leading: const Icon(Icons.auto_stories),
              title: const Text("Comprehension"),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard/readingcomp');
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Flashcard>>(
        future: flashcards,
        builder:
            (BuildContext context, AsyncSnapshot<List<Flashcard>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            print('here is your snapshot.data!::: ${snapshot.data}');
            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Center(
                      child: Text(
                        snapshot.data![index].word,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlashcardPage(
                            flashcard: snapshot.data![index],
                            flashcards: snapshot.data!,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: Text('You have no flashcards yet!'),
              );
            }
          }
        },
      ),
    );
  }
}

class FlashcardPage extends StatelessWidget {
  final Flashcard flashcard;
  final List<Flashcard> flashcards;

  const FlashcardPage(
      {super.key, required this.flashcard, required this.flashcards});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/loginpage');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: SpinWordWidget(
          flashcard: flashcard,
          flashcards: flashcards,
        ),
      ),
    );
  }
}

class SpinWordWidget extends StatefulWidget {
  final Flashcard flashcard;
  final List<Flashcard> flashcards;

  const SpinWordWidget({
    super.key,
    required this.flashcard,
    required this.flashcards,
  });

  @override
  SpinWordWidgetState createState() => SpinWordWidgetState();
}

class SpinWordWidgetState extends State<SpinWordWidget>
    with TickerProviderStateMixin {
  bool _showWord = true;
  bool _showImage = false;
  late AnimationController _controller;
  late AnimationController _imageController;
  late Animation<double> _rotateWordAnimation;
  late Animation<double> _imageAnimation;
  late Animation<Offset> _imageSlideUpAnimation;
  late Animation<Offset> _definitionSlideDownAnimation;
  late Animation<double> _definitionFadeAnimation;
  late Animation<double> _imageFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _imageController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _rotateWordAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _imageAnimation = Tween<double>(begin: 0, end: 1).animate(_imageController);
    _imageSlideUpAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 0)).animate(
            CurvedAnimation(parent: _imageController, curve: Curves.easeInOut));
    _definitionSlideDownAnimation = Tween<Offset>(
            begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _definitionFadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _imageFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _imageController, curve: Curves.easeInOut));
  }

  void _toggleWord() {
    if (_showWord) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _showWord = !_showWord;
  }

  void _toggleImage() {
    if (_showImage) {
      _imageController.reverse();
    } else {
      _imageController.forward();
    }
    _showImage = !_showImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _imageAnimation,
              builder: (context, child) {
                return SlideTransition(
                  position: _imageSlideUpAnimation,
                  child: FadeTransition(
                    opacity: _imageFadeAnimation,
                    child: AnimatedCrossFade(
                      firstChild: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(
                            widget.flashcard.imageUrl,
                            height: 150,
                          ),
                          Text('Source: ${widget.flashcard.imgSource}'),
                          const SizedBox(height: 20),
                        ],
                      ),
                      secondChild: Container(),
                      crossFadeState: _showImage
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: _toggleWord,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _rotateWordAnimation,
                    builder: (context, child) {
                      return Transform(
                        alignment: FractionalOffset.center,
                        transform: Matrix4.rotationY(
                            _rotateWordAnimation.value * 3.14),
                        child: _rotateWordAnimation.value <= 0.5
                            ? Text(widget.flashcard.word,
                                style: const TextStyle(fontSize: 28))
                            : Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(3.14),
                                child: Text(widget.flashcard.translation,
                                    style: const TextStyle(fontSize: 28)),
                              ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedBuilder(
                      animation: _rotateWordAnimation,
                      builder: (context, child) {
                        return AnimatedCrossFade(
                          firstChild: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              const Divider(),
                              Text(
                                widget.flashcard.sentence,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          secondChild: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              const Divider(),
                              Text(
                                widget.flashcard.translatedSentence,
                                style: const TextStyle(
                                    fontSize: 20, fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8.0, // gap between adjacent chips
                                runSpacing: 4.0, // gap between lines
                                children: widget.flashcard.synonyms
                                    .map((String synonym) {
                                  return GestureDetector(
                                    onTap: () {
                                      Flashcard? flashcard = widget.flashcards
                                          .firstWhere(
                                              (card) => card.word == synonym,
                                              orElse: () => null as Flashcard);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FlashcardPage(
                                            flashcard: flashcard,
                                            flashcards: widget.flashcards,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Chip(
                                      label: Text(synonym),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          crossFadeState: _showWord
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              // todo: make language dynamic ('ar' for Arabic, 'ur' for Urdu, etc.)
              await speak(widget.flashcard.word, 'ur');
            },
            child: const Icon(Icons.volume_up),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(widget.flashcard.hint),
                ),
              );
            },
            child: const Icon(Icons.lightbulb_outline),
          ),
          const SizedBox(width: 10), // Add some spacing between the buttons
          ElevatedButton(
            onPressed: _toggleImage,
            child: const Icon(Icons.image),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
