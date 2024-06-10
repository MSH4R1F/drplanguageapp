import 'package:flutter/material.dart';

void main() {
  runApp(WordsListPage());
}

class Flashcard {
  final String word;
  final String translation;
  final String definition;
  final List<String> synonyms;
  final String imageUrl;
  final String imgSource;
  final String hint;

  Flashcard({
    required this.word,
    required this.translation,
    required this.definition,
    required this.synonyms,
    required this.imageUrl,
    required this.imgSource,
    required this.hint,
  });
}

class WordsListPage extends StatelessWidget {
  // todo: get flashcards from the database instead :>
  final List<Flashcard> flashcards = [
    Flashcard(
        word: 'مرحبًا',
        translation: 'hello',
        definition:
            'A greeting used to begin a conversation or to acknowledge someone\'s presence.',
        synonyms: ['صباح الخير', 'ترحيب'],
        imageUrl:
            'https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/04/03/17/donald-trump-sisi.jpg?width=1200',
        imgSource: 'The Independent',
        hint: 'This word is used to greet someone.'),
    Flashcard(
        word: 'ترحيب',
        translation: 'welcome',
        definition:
            'A greeting or expression of goodwill given upon someone\'s arrival.',
        synonyms: ['صباح الخير', 'مرحبًا'],
        imageUrl:
            'https://previews.123rf.com/images/perig76/perig761410/perig76141000059/32314128-view-of-a-young-attractive-man-welcoming-you-in-his-house.jpg',
        imgSource: '123RF',
        hint: 'This word is used to greet someone.'),
    Flashcard(
        word: 'صباح الخير',
        translation: 'good morning',
        definition:
            'A greeting used to acknowledge or welcome someone during the morning hours.',
        synonyms: ['ترحيب', 'مرحبًا'],
        imageUrl:
            'https://i.pinimg.com/736x/d1/8a/69/d18a69b3b01b6f80aa192e26fc622324.jpg',
        imgSource: 'Pinterest',
        hint: 'This word is used to greet someone in the morning.'),
  ];

  WordsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Flashcards'),
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
        body: ListView.builder(
          itemCount: flashcards.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Center(
                  child: Text(flashcards[index].word,
                      style: const TextStyle(fontSize: 24))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlashcardPage(
                      flashcard: flashcards[index],
                      flashcards: flashcards,
                    ),
                  ),
                );
              },
            );
          },
        ),
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flashcard'),
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
  bool _showFirstWord = true;
  late AnimationController _controller;
  late AnimationController _imageController;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideUpAnimation;
  late Animation<Offset> _slideDownAnimation;
  late Animation<double> _fadeInFadeOutAnimation;

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
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _slideUpAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1)).animate(
            CurvedAnimation(parent: _imageController, curve: Curves.easeInOut));
    _slideDownAnimation = Tween<Offset>(
            begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _fadeInFadeOutAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _toggleWord() {
    if (_showFirstWord) {
      _controller.forward();
      _imageController.reverse();
    } else {
      _controller.reverse();
      _imageController.forward();
    }
    _showFirstWord = !_showFirstWord;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: _toggleWord,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return SlideTransition(
                    position: _slideUpAnimation,
                    child: FadeTransition(
                      opacity: _fadeInFadeOutAnimation,
                      child: Visibility(
                        visible: _rotationAnimation.value > 0.5,
                        child: Column(
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
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform(
                    alignment: FractionalOffset.center,
                    transform:
                        Matrix4.rotationY(_rotationAnimation.value * 3.14),
                    child: _rotationAnimation.value <= 0.5
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
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return SlideTransition(
                    position: _slideDownAnimation,
                    child: FadeTransition(
                      opacity: _fadeInFadeOutAnimation,
                      child: Visibility(
                        visible: _rotationAnimation.value > 0.5,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              widget.flashcard.definition,
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
                                    if (flashcard != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FlashcardPage(
                                            flashcard: flashcard,
                                            flashcards: widget.flashcards,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Chip(
                                    label: Text(synonym),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.flashcard.hint),
            ),
          );
        },
        child: const Icon(Icons.lightbulb_outline),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
