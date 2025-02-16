import "package:flutter/services.dart";
import "dart:convert";

class AppSettings {
  static Map<String, dynamic> settings = {};

  static Future<void> loadSettings() async {
    try {
      final jsonString = await rootBundle.loadString('assets/settings.json');
      settings = jsonDecode(jsonString);
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  static double get difficultyEasyValue =>
      settings['difficultyValues']['easy'] ?? 0.5;
  static double get difficultyMediumValue =>
      settings['difficultyValues']['medium'] ?? 0.75;
  static double get difficultyHardValue =>
      settings['difficultyValues']['hard'] ?? 1.0;
  static double get locationRadius => settings['locationRadius'] ?? 100.0;
}
