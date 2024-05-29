import 'package:drplanguageapp/pages/conversation.dart';
import 'package:drplanguageapp/pages/dashboard_page.dart';
import 'package:drplanguageapp/pages/highlights.dart';
import 'package:drplanguageapp/pages/login_page.dart';
import 'package:drplanguageapp/pages/reading_comp.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue[400]!),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Bloom'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      home: const LoginScreen(),
      routes: {
        '/loginpage': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardPage(),
        '/dashboard/conversation': (context) => const Conversation(),
        '/dashboard/readingcomp': (context) => const ReadingComp(),
        '/dashboard/highlights': (context) => const Highlights()
      }
    );
  }
}
