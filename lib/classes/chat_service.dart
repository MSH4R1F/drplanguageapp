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

  Future<String?> request(String prompt, {int? maxTokens}) async {
    var body = {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': 'You are a helpful assistant'},
        {'role': 'user', 'content': prompt}
      ],
    };

    if (maxTokens == null) {
      body['max_tokens'] = 100;
    }

    try {
      var response = await http.post(
        _url,
        headers: _headers,
        body: json.encode(body),
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

  Future<String?> requestResponse(
      String prompt, String language, String topic) async {
    int maxTokens = 200;
    try {
      var response = await http.post(
        _url,
        headers: _headers,
        body: json.encode({
          // Encode the body to a JSON string
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are an AI assistant engaging in a conversation with the user, who is talking about $topic in $language. Give him follow-up questions allowing them to practise their language on you. Following this, separate your response with a % and give an improvement/advice if any to the message the user sent to help improve their language.'
            },
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

  Future<String> requestAudio(String filename) async {
    try {
      var url = Uri.parse('https://api.openai.com/v1/audio/transcriptions');
      var headers = {
        'Authorization': 'Bearer ${ApiKey.openAIKey}',
        'Content-Type': 'multipart/form-data'
      };
      print("hello world");
      var body = json
          .encode({'model': "whisper-1", 'language': "ar", 'audio': filename});
      var response = await http.post(url, headers: headers, body: body);
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseBody['transcription'] != null) {
        String transcription = responseBody['transcription'];
        print(transcription);
      } else {
        return 'No transcription available';
      }
    } catch (e) {
      print(e);
    }
    return 'Error';
  }
}
