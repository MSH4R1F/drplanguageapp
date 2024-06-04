import 'package:http/http.dart' as http;
import 'package:drplanguageapp/api_key.dart';

class ChatService {
  static final Uri _url =
      Uri.parse('https://api.openai.com/v1/chat/completions');
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${ApiKey.openAIKey}',
  };
  Future<String?> request() async {
    String prompt = "Hello, how are you doing?";
    int maxTokens = 50;
    try {
      var response = await http.post(
        _url,
        headers: _headers,
        body: {
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant.'},
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': maxTokens,
        },
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
