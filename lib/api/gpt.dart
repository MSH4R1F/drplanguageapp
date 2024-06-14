import 'package:drplanguageapp/classes/chat_service.dart';

class TextGenerator {
  final ChatService gpt = ChatService();
  static String? text;

  Future<String?> generateText(String prompt) async {
    return await gpt.request(prompt, maxTokens: 10000);
  }

  Future<String> getText(String prompt) async {
    text ??= await generateText(prompt);
    return text!;
  }

  void eraseText() {
    text = null;
  }

  void regenerateText(String prompt) async {
    text = null;
    text = await generateText(prompt);
  }
}
