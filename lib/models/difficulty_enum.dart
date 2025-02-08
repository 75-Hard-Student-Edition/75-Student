//todo Probably move these to a settings file too
const double EASY_VALUE = 0.5;
const double MEDIUM_VALUE = 1.0;
const double HARD_VALUE = 1.5;

enum Difficulty { easy, medium, hard }

extension DifficultyExtension on Difficulty {
  double get value {
    switch (this) {
      case Difficulty.easy:
        return EASY_VALUE;
      case Difficulty.medium:
        return MEDIUM_VALUE;
      case Difficulty.hard:
        return HARD_VALUE;
    }
  }
}
