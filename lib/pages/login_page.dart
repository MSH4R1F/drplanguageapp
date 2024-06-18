import 'dart:math';

import 'package:drplanguageapp/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> updateStreak(String userID) async {
    var userRef = FirebaseFirestore.instance.collection('users').doc(userID);
    var snapshot = await userRef.get();
    var data = snapshot.data() as Map<String, dynamic>;

    DateTime today = DateTime.now();
    DateTime lastActive = data['lastActive'] == null
        ? today
        : (data['lastActive'] as Timestamp).toDate();
    DateTime startOfToday = DateTime(today.year, today.month, today.day);
    DateTime yesterday = startOfToday.subtract(const Duration(days: 1));

    int streak = 1;
    if (lastActive.isAtSameMomentAs(yesterday) ||
        lastActive.isAfter(yesterday) && lastActive.isBefore(startOfToday)) {
      streak = data['streak'] + 1;
    }

    await userRef.set({
      'streak': streak,
      'maxStreak': max<int>(streak, data['maxStreak'] ?? 0),
      'displayName': userID,
      'lastActive': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Login to Bloom"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/bloom.png'),
              child: Text(
                '',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const Text(
              'Bloom',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 40)),
            ElevatedButton(
              onPressed: () {
                updateStreak('Mahdi');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DashboardPage(
                      userID: 'Mahdi',
                    ),
                  ),
                );
              },
              child: const Text('Mahdi'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateStreak('Humza');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DashboardPage(
                      userID: 'Humza',
                    ),
                  ),
                );
              },
              child: const Text('Humza'),
            ),
          ],
        ),
      ),
    );
  }
}
