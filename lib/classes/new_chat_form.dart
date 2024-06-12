import 'package:flutter/material.dart';

class LanguageTopicForm extends StatefulWidget {
  const LanguageTopicForm({super.key});

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
        title: const Text('Language and Topic Selection'),
      ),
      body: SingleChildScrollView(
        // Wrap your Column in a SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Choose a Language:', style: TextStyle(fontSize: 18)),
              DropdownButton<String>(
                isExpanded:
                    true, // Set isExpanded to true for better UI experience
                value: _selectedLanguage,
                hint: const Text('Select Language'),
                items: ['Arabic', 'Urdu', 'Bengali'].map((String value) {
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
              const SizedBox(height: 20),
              const Text('Choose a Topic:', style: TextStyle(fontSize: 18)),
              if (_selectedLanguage != null)
                ...topics.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.key,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
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
                      }),
                    ],
                  );
                }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_selectedLanguage != null && _selectedTopic != null) {
                    Navigator.pop(
                        context,
                        Selection(
                            language: _selectedLanguage!,
                            topic: _selectedTopic!));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Please select both language and topic')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
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
    return "Language: $language, topic: $topic";
  }
}
