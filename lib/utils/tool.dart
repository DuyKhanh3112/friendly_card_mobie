// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:convert';

import 'package:flutter_tts/flutter_tts.dart';

class Tool {
  static String extractJsonArray(String input) {
    final regex = RegExp(r'```json\s*(\[.*?\])\s*```', dotAll: true);
    final match = regex.firstMatch(input);
    if (match != null) {
      return match.group(1)!;
    }
    return '[]';
  }

  static List<Map<String, dynamic>> parseList(String rawText) {
    final jsonArrayString = extractJsonArray(rawText);
    final parsed = json.decode(jsonArrayString);
    return List<Map<String, dynamic>>.from(parsed);
  }

  static String convertNumberToChar(int num) {
    List<String> listChar = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z'
    ];
    return num >= listChar.length ? '' : listChar[num];
  }

  static Future<void> textToSpeak(String text, String language) async {
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage(language); // hỗ trợ "vi-VN", "en-US", ...
    await flutterTts.setPitch(1); // 0.5 - 2.0
    await flutterTts.setSpeechRate(0.5); // 0.0 - 1.0
    await flutterTts.setVolume(1.0); // 0.0 - 1.0
    await flutterTts.speak(text);
  }

  static String formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final twoDigits = (int n) => n.toString().padLeft(2, '0');
    final minute = twoDigits(date.minute);
    final hour = twoDigits(date.hour);
    final day = twoDigits(date.day);
    final month = twoDigits(date.month);
    final year = date.year;
    return '$minute:$hour $day/$month/$year';
  }
}
