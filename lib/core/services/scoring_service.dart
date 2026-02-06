import 'dart:math';
import '../models/game_level.dart';

class ScoringService {
  int calculateScore({
    required int level,
    required int timeRemaining,
    required int comboStreak,
    required DifficultyTier tier,
  }) {
    final baseScore = _getBaseScore(level, tier);
    final levelMultiplier = _getLevelMultiplier(level);
    final timeBonus = _calculateTimeBonus(timeRemaining, level);
    final comboBonus = _calculateComboBonus(comboStreak, level);
    final tierBonus = _getTierBonus(tier);

    return ((baseScore * levelMultiplier) + timeBonus + comboBonus + tierBonus)
        .round();
  }

  int _getBaseScore(int level, DifficultyTier tier) {
    switch (tier) {
      case DifficultyTier.beginner:
        return 100;
      case DifficultyTier.intermediate:
        return 250;
      case DifficultyTier.advanced:
        return 500;
      case DifficultyTier.expert:
        return 1000;
    }
  }

  double _getLevelMultiplier(int level) {
    if (level <= 10) return 1.0 + (level * 0.1);
    if (level <= 30) return 2.0 + ((level - 10) * 0.15);
    if (level <= 70) return 5.0 + ((level - 30) * 0.2);
    return 13.0 + ((level - 70) * 0.3);
  }

  int _calculateTimeBonus(int timeRemaining, int level) {
    final basePerSecond =
        level <= 10
            ? 10
            : level <= 30
            ? 25
            : level <= 70
            ? 50
            : 100;
    return timeRemaining * basePerSecond;
  }

  int _calculateComboBonus(int comboStreak, int level) {
    if (comboStreak < 3) return 0;

    final baseComboBonus = 50;
    final streakMultiplier = pow(1.5, comboStreak - 2).toDouble();
    final levelBonus = level * 5;

    return (baseComboBonus * streakMultiplier + levelBonus).round();
  }

  int _getTierBonus(DifficultyTier tier) {
    switch (tier) {
      case DifficultyTier.beginner:
        return 0;
      case DifficultyTier.intermediate:
        return 500;
      case DifficultyTier.advanced:
        return 2000;
      case DifficultyTier.expert:
        return 5000;
    }
  }

  int getTimePenalty(int level) {
    if (level <= 10) return 1;
    if (level <= 30) return 2;
    if (level <= 70) return 3;
    return 4;
  }
}
