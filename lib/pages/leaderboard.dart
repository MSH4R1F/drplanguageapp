import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drplanguageapp/classes/mounted_state.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends MountedState<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Leaderboard",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .orderBy('streak', descending: true)
              .limit(3)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // Table-like border
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data['displayName'] ?? 'Anonymous',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            '${data['streak']} ${data['streak'] == 1 ? 'day' : 'days'}',
                            style: const TextStyle(color: Colors.blue)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
