import 'package:drplanguageapp/pages/conversations_list.dart';
import 'package:drplanguageapp/pages/dashboard_page.dart';
import 'package:drplanguageapp/pages/dialogue_page.dart';
import 'package:drplanguageapp/pages/flashcards.dart';
import 'package:drplanguageapp/pages/login_page.dart';
import 'package:drplanguageapp/pages/selection_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final FlutterTts flutterTts = FlutterTts();

Future<void> speak(String text, String language) async {
  await flutterTts.setLanguage(language);
  await flutterTts.speak(text);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      onGenerateRoute: (RouteSettings settings) {
        // todo : change userID
        // final userID = settings.arguments as String;
        // final userID = "userID";

        // Handling each route
        switch (settings.name) {
          case '/loginpage':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/dashboard':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => DashboardPage(
                userID: args!['userID'],
              ),
            );
          case '/dashboard/conversation':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
                builder: (_) => ConversationsList(userID: args!['userID']));
          case '/selection':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => SelectionPage(
                userID: args!['userID'],
                language: args['language'],
                difficulty: args['difficulty'],
              ),
            );
          case '/dashboard/comprehension':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => DialoguePage(
                userID: args!['userID'],
                language: args['language'],
                difficulty: args['difficulty'],
              ),
            );
          case '/dashboard/flashcards':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
                builder: (_) => WordsListPage(
                      userID: args!['userID'],
                    ));
          default:
            return MaterialPageRoute(
                builder: (_) =>
                    const Scaffold(body: Center(child: Text('Not Found'))));
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginScreen(),
    );
  }
}
