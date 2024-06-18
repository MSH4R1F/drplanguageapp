import 'package:drplanguageapp/classes/mounted_state.dart';
import 'package:drplanguageapp/pages/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Streak {
  final String userID;
  int? currStreak;
  int? maxStreak;

  Future<void> initStreaks() async {
    if (currStreak == null || maxStreak == null) {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get();
      currStreak = snapshot.data()!['streak'];
      maxStreak = snapshot.data()!['maxStreak'];
    }
    print(currStreak);
  }

  Streak({required this.userID}) {
    initStreaks();
  }
}

class DashboardPage extends StatefulWidget {
  final String userID;
  const DashboardPage({super.key, required this.userID});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends MountedState<DashboardPage> {
  final String userUID = 'Bmoy5vB0vYQQekDx7V87IqIZz043';

  Future<String> fetchUserNameByUID(String userUID) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('userUID', isEqualTo: userUID)
        .get();

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
              child: Text(
                'Welcome Back ${widget.userID}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // FutureBuilder(
              //   future: fetchUserNameByUID(userUID),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.done) {
              //       return Text(
              //         'Welcome Back ${widget.userID}!',
              //         style: const TextStyle(
              //             fontSize: 24, fontWeight: FontWeight.bold),
              //       );
              //     } else if (snapshot.hasError) {
              //       return Text('Error: ${snapshot.error}');
              //     } else {
              //       return const CircularProgressIndicator();
              //     }
              //   },
              // ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'Current Streak',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.userID)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('Something went wrong');
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                var data = snapshot.data;
                                int streak = data!['streak'];
                                return Text(
                                  '$streak ${streak == 1 ? 'day' : 'days'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                );
                              },
                            ),
                            // Text(
                            //   '${widget.streak!.currStreak} ${widget.streak!.currStreak == 1 ? 'day' : 'days'}',
                            //   style: const TextStyle(
                            //     fontSize: 16,
                            //   ),
                            // ),
                          ],
                        ),
                      )),
                    ),
                    // Max streak card
                    Expanded(
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'Max Streak',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.userID)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('Something went wrong');
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                var data = snapshot.data;
                                int maxStreak = data!['maxStreak'];
                                return Text(
                                  '$maxStreak ${maxStreak == 1 ? 'day' : 'days'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                );
                              },
                            ),
                            // Text(
                            //   '${streak!.maxStreak} ${streak!.maxStreak == 1 ? 'day' : 'days'}',
                            //   style: const TextStyle(
                            //     fontSize: 16,
                            //   ),
                            // ),
                          ],
                        ),
                      )),
                    ),
                  ],
                )),
            FeatureCard(
              title: 'Conversation',
              link: '/dashboard/conversation',
              args: {'userID': widget.userID},
            ),
            FeatureCard(
              title: 'Reading Comp',
              link: '/selection',
              args: {
                'userID': widget.userID,
                'language': null,
                'difficulty': null
              },
            ),
            FeatureCard(
              title: 'Flashcards',
              link: '/dashboard/flashcards',
              args: {'userID': widget.userID},
            ),
            // Image.network("https://i.pinimg.com/originals/83/cd/af/83cdaf182b196bad532ca40f761095ca.gif")
            const SizedBox(
              height: 40,
            ),
            const Leaderboard(),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String link;
  final Map<String, dynamic> args;
  const FeatureCard(
      {super.key, required this.title, required this.link, required this.args});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.pushNamed(context, link, arguments: args);
        },
      ),
    );
  }
}
