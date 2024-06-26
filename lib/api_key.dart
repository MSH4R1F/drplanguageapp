import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKey {
  static String get openAIKey => dotenv.env['OPENAI_KEY']!;
}
