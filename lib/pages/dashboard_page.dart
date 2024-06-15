import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  final String userUID = 'Bmoy5vB0vYQQekDx7V87IqIZz043';

  Future<String> fetchUserNameByUID(String userUID) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('userUID', isEqualTo: userUID)
        .get();

    // log the querySnapshot using a logging framework but print in red
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.get('Name');
    } else {
      return 'User not found';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder(
                future: fetchUserNameByUID(userUID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(
                      'Welcome Back ${snapshot.data}!',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
            const Padding(
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
            FeatureCard(
              title: 'Conversation',
              link: '/dashboard/conversation',
              userID: userUID,
            ),
            FeatureCard(
              title: 'Reading Comp',
              link: '/selection',
              userID: userUID,
            ),
            FeatureCard(
              title: 'Flashcards',
              link: '/dashboard/flashcards',
              userID: userUID,
            ),
            // Image.network("https://i.pinimg.com/originals/83/cd/af/83cdaf182b196bad532ca40f761095ca.gif")
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String link;
  final String userID;
  const FeatureCard(
      {super.key,
      required this.title,
      required this.link,
      required this.userID});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.pushNamed(context, link, arguments: userID);
        },
      ),
    );
  }
}
