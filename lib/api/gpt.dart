import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drplanguageapp/classes/chat_service.dart';

class TextGenerator {
  final ChatService gpt = ChatService();
  final String userID;
  final String language;
  final String difficulty;
  late final String prompt;

  TextGenerator(
      {required this.userID,
      required this.language,
      required this.difficulty}) {
    prompt =
        "Give a paragraph of about 200 words in $language, using only $difficulty level vocab, without any additional text or introduction";
  }

  Future<String?> generateText() async {
    return await gpt.request(prompt, maxTokens: 10000);
  }

  Future<String> getText() async {
    var docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('texts')
        .doc(language + difficulty);
    try {
      var snapshot = await docRef.get();

      if (snapshot.exists) {
        return snapshot.data()!['text'];
      } else {
        String? text = await generateText();
        if (text != null) {
          docRef.set({'text': text});
          return text;
        } else {
          throw Exception('Generated text was null');
        }
      }
    } catch (e) {
      print('Error accessing Firestore or generating text: $e');
      return "";
    }
  }

  void regenerateText() async {
    await FirebaseFirestore.instance
        .doc('users/$userID/texts/${language + difficulty}')
        .delete();
  }
}
