import 'package:drplanguageapp/classes/mounted_state.dart';

import 'package:flutter/material.dart';

class SelectionPage extends StatefulWidget {
  final String userID;
  final String? language;
  final String? difficulty;
  const SelectionPage(
      {super.key, required this.userID, this.language, this.difficulty});

  @override
  State<StatefulWidget> createState() => _SelectionPageState();
}

class _SelectionPageState extends MountedState<SelectionPage> {
  String? selectedLanguage;
  String? selectedDifficulty;

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.language;
    selectedDifficulty = widget.difficulty;
  }

  final List<String> languageOptions = [
    "Arabic",
    "Urdu",
    "Bangla",
  ];
  final List<String> difficulties = ["Beginner", "Intermediate", "Advanced"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comprehension"),
        centerTitle: true,
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/dashboard',
              arguments: {'userID': widget.userID},
            ),
            icon: const Icon(Icons.dashboard),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.lime,
        child: Column(
          children: [
            const DrawerHeader(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/bloom.png'),
                radius: 50,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble),
              title: const Text("Conversation"),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/dashboard/conversation',
                  arguments: {'userID': widget.userID},
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.subtitles),
              title: const Text("Flashcards"),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/dashboard/flashcards',
                  arguments: {'userID': widget.userID},
                );
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/loginpage', (Route<dynamic> route) => false);
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PopupMenuButton<String>(
              constraints: BoxConstraints.expand(
                  width: MediaQuery.of(context).size.width, height: 150),
              onSelected: (String value) {
                setState(() {
                  selectedLanguage = value;
                });
              },
              itemBuilder: (BuildContext context) {
                return languageOptions.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              child: ListTile(
                title: Text(selectedLanguage ?? 'Choose a Language'),
                trailing: const Icon(Icons.arrow_drop_down),
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Select difficulty:",
              style: TextStyle(fontSize: 18),
            ),
            ...difficulties.map(
              (difficulty) => RadioListTile(
                title: Text(difficulty),
                value: difficulty,
                groupValue: selectedDifficulty,
                onChanged: (String? value) {
                  setState(() {
                    selectedDifficulty = value;
                  });
                },
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (selectedLanguage == null && selectedDifficulty == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Please choose a language and select a difficulty"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    '/dashboard/comprehension',
                    arguments: {
                      'userID': widget.userID,
                      'language': selectedLanguage,
                      'difficulty': selectedDifficulty,
                    },
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
