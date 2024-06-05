import 'dart:convert';

import 'package:drplanguageapp/api/gpt_api_key.dart';
import 'package:http/http.dart' as http;

class TextGenerator {
  static final Uri _url =
      Uri.parse('https://api.openai.com/v1/chat/completions');
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${ApiKey.openAIKey}',
  };
  Future<String?> generateText(String prompt) async {
    try {
      var response = await http.post(_url,
          headers: _headers,
          body: json.encode({
            'model': 'gpt-3.5-turbo',
            'messages': [
              {'role': 'user', 'content': prompt},
            ],
          }));
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseBody['choices'] != null && !responseBody['choices'].isEmpty) {
        return responseBody['choices'][0]['message']['content'];
      } else {
        print("No choices available");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
