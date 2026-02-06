import 'game_item.dart';

enum DifficultyTier { beginner, intermediate, advanced, expert }

class GameLevel {
  final int levelNumber;
  final int gridSize;
  final int timeLimit;
  final ItemType itemType;
  final DifficultyConfig difficulty;

  GameLevel({
    required this.levelNumber,
    required this.gridSize,
    required this.timeLimit,
    required this.itemType,
    required this.difficulty,
  });
}

class DifficultyConfig {
  final int gridSize;
  final int timeLimitSeconds;
  final double visualDifferenceIntensity;
  final DifficultyTier tier;
  final int difficultyLevel;
  final bool useSubtleColors;
  final bool useMicroDifferences;
  final bool useMultiAttribute;
  final bool usePatternMisdirection;
  final bool showFeedback;
  final double rotationVariance;
  final double sizeVariance;
  final double opacityVariance;
  final int attributeDiffCount;

  DifficultyConfig({
    required this.gridSize,
    required this.timeLimitSeconds,
    required this.visualDifferenceIntensity,
    required this.tier,
    required this.difficultyLevel,
    this.useSubtleColors = false,
    this.useMicroDifferences = false,
    this.useMultiAttribute = false,
    this.usePatternMisdirection = false,
    this.showFeedback = true,
    this.rotationVariance = 0.0,
    this.sizeVariance = 0.0,
    this.opacityVariance = 0.0,
    this.attributeDiffCount = 1,
  });
}
