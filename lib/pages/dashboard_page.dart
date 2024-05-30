import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Welcome Back User!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Card(
                          child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('Current Streak',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('5 days', style: TextStyle(fontSize: 16))
                          ],
                        ),
                      )),
                    ),
                    // Max streak card
                    Expanded(
                      child: Card(
                          child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('Max Streak',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('10 days', style: TextStyle(fontSize: 16))
                          ],
                        ),
                      )),
                    ),
                  ],
                )),
            FeatureCard(title: 'Conversation', link: '/dashboard/conversation'),
            FeatureCard(title: 'Reading Comp', link: '/dashboard/readingcomp'),
            FeatureCard(title: 'Highlights', link: '/dashboard/highlights'),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String link;
  const FeatureCard({super.key, required this.title, required this.link});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.pushNamed(context, link);
        },
      ),
    );
  }
}
