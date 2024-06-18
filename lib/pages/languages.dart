import 'package:flutter/material.dart';

class Language {
  final Map<String, String> tts = {
    "Arabic": "ar",
    "Urdu": "ur",
    "Bangla": "bn-BD"
  };

  final Map<String, TextDirection> directions = {
    "Arabic": TextDirection.rtl,
    "Urdu": TextDirection.rtl,
    "Bangla": TextDirection.ltr,
  };

  String getSpeechCode(String language) {
    return tts[language]!;
  }

  TextDirection getTextDirection(String language) {
    return directions[language]!;
  }
}
