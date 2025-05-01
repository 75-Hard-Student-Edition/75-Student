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
    settings['difficultyValues']?['easy']?.toDouble() ?? 0.6;

static double get difficultyMediumValue =>
    settings['difficultyValues']?['medium']?.toDouble() ?? 0.75;

static double get difficultyHardValue =>
    settings['difficultyValues']?['hard']?.toDouble() ?? 0.9;
  static double get locationRadius => settings['locationRadius'] ?? 100.0;
  static int get backlogPeakDepth => settings['backlogPeakDepth'] ?? 3;
}
