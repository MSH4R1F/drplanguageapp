import 'package:flutter/material.dart';

class Langauge {
  final Map<String, String> tts = {
    "Arabic": "ar",
    "Urdu": "ur",
    "Bengali": "bn-BD"
  };

  final Map<String, TextDirection> directions = {
    "Arabic": TextDirection.rtl,
    "Urdu": TextDirection.rtl,
    "Bengali": TextDirection.ltr,
  };

  String getSpeechCode(String language) {
    return tts[language]!;
  }

  TextDirection getTextDirection(String language) {
    return directions[language]!;
  }
}
