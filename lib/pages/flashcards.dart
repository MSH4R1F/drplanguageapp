import 'package:flutter/material.dart';

void main() {
  runApp(const FlashcardsPage());
}

class FlashcardsPage extends StatelessWidget {
  const FlashcardsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flashcards'),
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
        body: const Center(
          child: SpinWordWidget(
            word1: 'مرحبًا',
            word2: 'hello',
            definition: 'A greeting used to begin a conversation or to acknowledge someone’s presence.',
            synonyms: ['هتاف للترحيب', 'ترحيب'],
            imageUrl: 'https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/04/03/17/donald-trump-sisi.jpg?width=1200', // my cutie pie sisi with big orange man
          ),
        ),
      ),
    );
  }
}

class SpinWordWidget extends StatefulWidget {
  final String word1;
  final String word2;
  final String definition;
  final List<String> synonyms;
  final String imageUrl;

  const SpinWordWidget({
    Key? key,
    required this.word1,
    required this.word2,
    required this.definition,
    required this.synonyms,
    required this.imageUrl,
  }) : super(key: key);

  @override
  SpinWordWidgetState createState() => SpinWordWidgetState();
}

class SpinWordWidgetState extends State<SpinWordWidget>
    with SingleTickerProviderStateMixin {
  bool _showFirstWord = true;
  late AnimationController _controller;
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
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _slideUpAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _slideDownAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _fadeInFadeOutAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _toggleWord() {
    if (_showFirstWord) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _showFirstWord = !_showFirstWord;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleWord,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return SlideTransition(
                position: _rotationAnimation.value <= 0.5 ? _slideUpAnimation : _slideDownAnimation,
                child: Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.rotationY(_rotationAnimation.value * 3.14),
                  child: _rotationAnimation.value <= 0.5
                      ? Text(widget.word1, style: const TextStyle(fontSize: 24))
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(3.14),
                          child: Text(widget.word2, style: const TextStyle(fontSize: 24)),
                        ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeInFadeOutAnimation,
                child: Visibility(
                  visible: _rotationAnimation.value > 0.5,
                  child: SlideTransition(
                    position: _slideDownAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Image.network(
                          widget.imageUrl,
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.definition,
                          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Synonyms: ${widget.synonyms.join('، ')}',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
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
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
