import 'package:drplanguageapp/pages/chat_page.dart';

class TextPair {
  final Chat text;
  final String suggestion;

  TextPair(this.text, this.suggestion);
  Chat get chat => text;
  String get suggestionText => suggestion;
}
