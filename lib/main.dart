import 'package:drplanguageapp/pages/conversations_list.dart';
import 'package:drplanguageapp/pages/dashboard_page.dart';
import 'package:drplanguageapp/pages/dialogue_page.dart';
import 'package:drplanguageapp/pages/flashcards.dart';
import 'package:drplanguageapp/pages/highlights.dart';
import 'package:drplanguageapp/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),

      onGenerateRoute: (RouteSettings settings) {
        // Handling each route
        switch (settings.name) {
          case '/loginpage':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/dashboard':
            return MaterialPageRoute(builder: (_) => const DashboardPage());
          case '/dashboard/conversation':
            final userID = settings.arguments as String;
            return MaterialPageRoute(
                builder: (_) => ConversationsList(userID: userID));
          case '/dashboard/readingcomp':
            return MaterialPageRoute(builder: (_) => const DialoguePage());
          case '/dashboard/highlights':
            return MaterialPageRoute(builder: (_) => const Highlights());
          case '/dashboard/flashcards': 
            return MaterialPageRoute(builder: (_) => WordsListPage());
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
