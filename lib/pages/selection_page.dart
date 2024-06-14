import 'package:drplanguageapp/pages/dialogue_page.dart';
import 'package:flutter/material.dart';

class SelectionPage extends StatefulWidget {
  final String userID;
  const SelectionPage({super.key, required this.userID});

  @override
  State<StatefulWidget> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  final List<String> languageOptions = [
    "Arabic",
    "Urdu",
    "Bengali",
  ];
  final List<String> difficulties = ["Beginner", "Intermediate", "Advanced"];
  String? selectedLanguage;
  String? selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comprehension"),
        centerTitle: true,
        backgroundColor: Colors.amber,
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
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble),
              title: const Text("Conversation"),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard/conversation');
              },
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb),
              title: const Text("Highlights"),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard/highlights');
              },
            ),
            ListTile(
              leading: const Icon(Icons.subtitles),
              title: const Text("Flashcards"),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard/flashcards');
              },
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DialoguePage(
                              userID: widget.userID,
                              language: selectedLanguage!,
                              difficulty: selectedDifficulty!)));
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
