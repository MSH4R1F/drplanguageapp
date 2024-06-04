import 'package:http/http.dart' as http;
import 'dart:convert'; // Import JSON utilities
import 'package:drplanguageapp/api_key.dart';

class ChatService {
  static final Uri _url =
      Uri.parse('https://api.openai.com/v1/chat/completions');
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${ApiKey.openAIKey}',
  };

  Future<String?> request(String prompt) async {
    int maxTokens = 50;
    try {
      var response = await http.post(
        _url,
        headers: _headers,
        body: json.encode({
          // Encode the body to a JSON string
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant.'},
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': maxTokens,
        }),
      );
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      // Access nested data with proper null checks
      if (responseBody['choices'] != null &&
          responseBody['choices'].isNotEmpty) {
        String content = responseBody['choices'][0]['message']['content'];
        return content;
      } else {
        print('No choices available in the response.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
