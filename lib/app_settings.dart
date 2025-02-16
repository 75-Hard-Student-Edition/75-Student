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

  static double? get difficultyEasyValue =>
      settings['difficultyValues']['easy'];
  static double? get difficultyMediumValue =>
      settings['difficultyValues']['medium'];
  static double? get difficultyHardValue =>
      settings['difficultyValues']['hard'];
  static double? get locationRadius => settings['locationRadius'];
}
