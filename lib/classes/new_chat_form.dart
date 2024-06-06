import 'package:flutter/material.dart';


class LanguageTopicForm extends StatefulWidget {
  @override
  _LanguageTopicFormState createState() => _LanguageTopicFormState();
}

class _LanguageTopicFormState extends State<LanguageTopicForm> {
  String? _selectedLanguage;
  String? _selectedTopic;
  final Map<String, List<String>> topics = {
    'Easy': ['Greetings', 'Daily Routine', 'Family'],
    'Medium': ['Travel', 'Work', 'Hobbies'],
    'Hard': ['Politics', 'Technology', 'Philosophy']
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language and Topic Selection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose a Language:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _selectedLanguage,
              hint: Text('Select Language'),
              items: ['Arabic', 'Urdu'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedLanguage = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Choose a Topic:', style: TextStyle(fontSize: 18)),
            if (_selectedLanguage != null) ...topics.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.key, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ...entry.value.map((topic) {
                    return RadioListTile<String>(
                      title: Text(topic),
                      value: topic,
                      groupValue: _selectedTopic,
                      onChanged: (value) {
                        setState(() {
                          _selectedTopic = value;
                        });
                      },
                    );
                  }).toList(),
                ],
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedLanguage != null && _selectedTopic != null) {
                  // Handle form submission
                  Navigator.pop(context, Selection(language: _selectedLanguage!, topic: _selectedTopic!));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select both language and topic')),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class Selection {
  final String language;
  final String topic;

  Selection({required this.language, required this.topic});

  @override
  String toString() {
    // TODO: implement toString
    return "Language: ${language}, topic: ${topic}";
  }
}