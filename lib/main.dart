import 'package:drplanguageapp/pages/conversation.dart';
import 'package:drplanguageapp/pages/dashboard_page.dart';
import 'package:drplanguageapp/pages/dialogue_page.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      routes: {
        '/loginpage': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardPage(),
        '/dashboard/conversation': (context) => const Conversation(),
        '/dashboard/readingcomp': (context) => const DialoguePage(),
        '/dashboard/highlights': (context) => const Highlights(),
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
