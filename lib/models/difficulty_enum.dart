import 'package:student_75/app_settings.dart';
import 'package:student_75/models/difficulty_enum.dart';

enum Difficulty { easy, medium, hard }

extension DifficultyExtension on Difficulty {
  double get value {
    switch (this) {
      case Difficulty.easy:
        return AppSettings.difficultyEasyValue;
      case Difficulty.medium:
        return AppSettings.difficultyMediumValue;
      case Difficulty.hard:
        return AppSettings.difficultyHardValue;
    }
  }
}
