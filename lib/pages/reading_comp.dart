import 'package:flutter/material.dart';

class ReadingComp extends StatefulWidget {
  const ReadingComp({super.key});

  @override
  State<ReadingComp> createState() => _ReadingCompState();
}

class _ReadingCompState extends State<ReadingComp> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('READING COMP'),
      ),
    );
  }
}