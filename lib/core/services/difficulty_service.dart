import 'dart:math';
import '../models/game_level.dart';
import '../models/game_item.dart';

class DifficultyService {
  DifficultyTier getTierForLevel(int level) {
    if (level <= 10) return DifficultyTier.beginner;
    if (level <= 30) return DifficultyTier.intermediate;
    if (level <= 70) return DifficultyTier.advanced;
    return DifficultyTier.expert;
  }

  DifficultyConfig getConfigForLevel(int level) {
    final tier = getTierForLevel(level);
    final difficultyLevel = _calculateDifficultyLevel(level, tier);

    switch (tier) {
      case DifficultyTier.beginner:
        return _getBeginnerConfig(level, difficultyLevel);
      case DifficultyTier.intermediate:
        return _getIntermediateConfig(level, difficultyLevel);
      case DifficultyTier.advanced:
        return _getAdvancedConfig(level, difficultyLevel);
      case DifficultyTier.expert:
        return _getExpertConfig(level, difficultyLevel);
    }
  }

  int _calculateDifficultyLevel(int level, DifficultyTier tier) {
    switch (tier) {
      case DifficultyTier.beginner:
        return level;
      case DifficultyTier.intermediate:
        return level - 10;
      case DifficultyTier.advanced:
        return level - 30;
      case DifficultyTier.expert:
        return level - 70;
    }
  }

  DifficultyConfig _getBeginnerConfig(int level, int diffLevel) {
    return DifficultyConfig(
      tier: DifficultyTier.beginner,
      difficultyLevel: diffLevel,
      gridSize: min(6 + (diffLevel ~/ 3) * 3, 12),
      timeLimitSeconds: max(10 - (diffLevel ~/ 2), 6),
      visualDifferenceIntensity: 1.0 - (diffLevel * 0.03),
      useSubtleColors: diffLevel > 5,
      useMicroDifferences: false,
      useMultiAttribute: false,
      usePatternMisdirection: false,
      showFeedback: true,
      rotationVariance: 0.0,
      sizeVariance: 0.0,
      opacityVariance: 0.0,
      attributeDiffCount: 1,
    );
  }

  DifficultyConfig _getIntermediateConfig(int level, int diffLevel) {
    return DifficultyConfig(
      tier: DifficultyTier.intermediate,
      difficultyLevel: diffLevel,
      gridSize: min(12 + (diffLevel ~/ 5) * 4, 20),
      timeLimitSeconds: max(8 - (diffLevel ~/ 4), 5),
      visualDifferenceIntensity: 0.7 - (diffLevel * 0.02),
      useSubtleColors: true,
      useMicroDifferences: diffLevel > 10,
      useMultiAttribute: diffLevel > 8,
      usePatternMisdirection: diffLevel > 12,
      showFeedback: true,
      rotationVariance: min(diffLevel * 0.3, 5.0),
      sizeVariance: min(diffLevel * 0.01, 0.15),
      opacityVariance: min(diffLevel * 0.005, 0.08),
      attributeDiffCount: diffLevel > 15 ? 2 : 1,
    );
  }

  DifficultyConfig _getAdvancedConfig(int level, int diffLevel) {
    return DifficultyConfig(
      tier: DifficultyTier.advanced,
      difficultyLevel: diffLevel,
      gridSize: min(20 + (diffLevel ~/ 5) * 4, 25),
      timeLimitSeconds: max(6 - (diffLevel ~/ 8), 4),
      visualDifferenceIntensity: 0.4 - (diffLevel * 0.008),
      useSubtleColors: true,
      useMicroDifferences: true,
      useMultiAttribute: true,
      usePatternMisdirection: true,
      showFeedback: diffLevel < 20,
      rotationVariance: min(3.0 + diffLevel * 0.1, 8.0),
      sizeVariance: min(0.05 + diffLevel * 0.005, 0.12),
      opacityVariance: min(0.03 + diffLevel * 0.003, 0.06),
      attributeDiffCount: diffLevel > 25 ? 3 : 2,
    );
  }

  DifficultyConfig _getExpertConfig(int level, int diffLevel) {
    return DifficultyConfig(
      tier: DifficultyTier.expert,
      difficultyLevel: diffLevel,
      gridSize: min(25 + (diffLevel ~/ 10) * 4, 36),
      timeLimitSeconds: max(5 - (diffLevel ~/ 15), 3),
      visualDifferenceIntensity: max(0.15 - (diffLevel * 0.002), 0.05),
      useSubtleColors: true,
      useMicroDifferences: true,
      useMultiAttribute: true,
      usePatternMisdirection: true,
      showFeedback: false,
      rotationVariance: min(2.0 + diffLevel * 0.05, 3.0),
      sizeVariance: min(0.03 + diffLevel * 0.002, 0.05),
      opacityVariance: min(0.02 + diffLevel * 0.001, 0.03),
      attributeDiffCount: 3,
    );
  }

  ItemType getItemTypeForLevel(int level) {
    final types = [
      ItemType.shape,
      ItemType.color,
      ItemType.icon,
      ItemType.number,
      ItemType.symbol,
    ];
    return types[(level - 1) % types.length];
  }

  int getGridColumns(int gridSize) {
    if (gridSize <= 6) return 3;
    if (gridSize <= 12) return 3;
    if (gridSize <= 16) return 4;
    if (gridSize <= 20) return 5;
    if (gridSize <= 25) return 5;
    return 6;
  }
}
