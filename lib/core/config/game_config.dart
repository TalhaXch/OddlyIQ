/// Centralized game configuration constants
class GameConfig {
  GameConfig._();

  // App
  static const String appName = 'ODDLYIQ';
  static const String tagline = 'Find The Odd One';

  // Grid
  static const int minGridSize = 4;
  static const int maxGridSize = 36;

  // Time
  static const int defaultTimeSeconds = 10;
  static const int minTimeSeconds = 3;

  // Animation durations (milliseconds)
  static const int feedbackDuration = 300;
  static const int transitionDuration = 400;
  static const int splashDuration = 2000;

  // Scoring
  static const int baseScore = 100;
  static const double timeBonus = 10.0;
  static const double comboMultiplier = 0.1;
  static const int wrongPenaltySeconds = 2;

  // Spacing
  static const double gridSpacing = 8.0;
  static const double screenPadding = 16.0;
  static const double tileRadius = 8.0;
}
