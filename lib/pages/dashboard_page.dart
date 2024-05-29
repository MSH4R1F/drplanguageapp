import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard/conversation');
              },
              child:const Text('Conversation')
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard/readingcomp');
              },
              child: const Text('Reading Comp')
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard/highlights');
              },
              child: const Text('Highlights')
            ),
          ],
          ),
        ),
    );
  }
}