import '../../core/config/game_config.dart';
import '../../core/config/difficulty_config.dart';

/// Handles score calculation logic
class ScoreService {
  const ScoreService();

  /// Calculates score for completing a level
  int calculateScore({
    required int level,
    required int timeRemaining,
    required int maxTime,
    required int comboStreak,
  }) {
    final difficulty = DifficultyConfig.fromLevel(level);

    // Base score increases with difficulty tier
    int baseScore = GameConfig.baseScore;
    switch (difficulty.tier) {
      case DifficultyTier.beginner:
        baseScore = 100;
      case DifficultyTier.intermediate:
        baseScore = 150;
      case DifficultyTier.advanced:
        baseScore = 200;
      case DifficultyTier.expert:
        baseScore = 300;
    }

    // Time bonus (percentage of time remaining)
    final timeRatio = maxTime > 0 ? timeRemaining / maxTime : 0;
    final timeBonus = (baseScore * timeRatio * 0.5).round();

    // Combo multiplier
    final comboMultiplier = 1.0 + (comboStreak * GameConfig.comboMultiplier);

    // Final score
    final rawScore = baseScore + timeBonus;
    return (rawScore * comboMultiplier).round();
  }

  /// Gets time penalty for wrong answer (in seconds)
  int getTimePenalty(int level) {
    final difficulty = DifficultyConfig.fromLevel(level);

    switch (difficulty.tier) {
      case DifficultyTier.beginner:
        return 2;
      case DifficultyTier.intermediate:
        return 2;
      case DifficultyTier.advanced:
        return 3;
      case DifficultyTier.expert:
        return 3;
    }
  }
}
