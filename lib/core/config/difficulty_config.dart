/// Difficulty tiers with deterministic level mapping
enum DifficultyTier {
  beginner, // Levels 1-10
  intermediate, // Levels 11-30
  advanced, // Levels 31-70
  expert, // Levels 71+
}

/// Centralized difficulty configuration
/// All difficulty values are deterministic based on level number
class DifficultyConfig {
  final DifficultyTier tier;
  final int gridSize;
  final int timeSeconds;
  final double colorDeltaMin;
  final double shapeDeltaMin;
  final bool allowMultiAttribute;
  final bool useMisdirection;

  const DifficultyConfig({
    required this.tier,
    required this.gridSize,
    required this.timeSeconds,
    required this.colorDeltaMin,
    required this.shapeDeltaMin,
    this.allowMultiAttribute = false,
    this.useMisdirection = false,
  });

  /// Deterministic difficulty calculation from level number
  factory DifficultyConfig.fromLevel(int level) {
    final tier = _getTier(level);

    switch (tier) {
      case DifficultyTier.beginner:
        return DifficultyConfig(
          tier: tier,
          gridSize: 4 + ((level - 1) ~/ 3) * 2, // 4, 4, 4, 6, 6, 6, 8, 8, 8, 10
          timeSeconds: 12 - (level ~/ 4), // 12 -> 10
          colorDeltaMin: 60.0 - (level * 3), // Large deltas
          shapeDeltaMin: 0.3 - (level * 0.02),
        );

      case DifficultyTier.intermediate:
        final localLevel = level - 10;
        return DifficultyConfig(
          tier: tier,
          gridSize: 9 + (localLevel ~/ 5) * 3, // 9 -> 21
          timeSeconds: 10 - (localLevel ~/ 8), // 10 -> 8
          colorDeltaMin: 40.0 - (localLevel * 1.0), // 40 -> 20
          shapeDeltaMin: 0.2 - (localLevel * 0.005),
          allowMultiAttribute: localLevel > 10,
        );

      case DifficultyTier.advanced:
        final localLevel = level - 30;
        return DifficultyConfig(
          tier: tier,
          gridSize: 16 + (localLevel ~/ 10) * 4, // 16 -> 32
          timeSeconds: 8 - (localLevel ~/ 15), // 8 -> 6
          colorDeltaMin: 25.0 - (localLevel * 0.3), // 25 -> 13
          shapeDeltaMin: 0.12 - (localLevel * 0.001),
          allowMultiAttribute: true,
          useMisdirection: localLevel > 20,
        );

      case DifficultyTier.expert:
        final localLevel = level - 70;
        return DifficultyConfig(
          tier: tier,
          gridSize: (28 + (localLevel ~/ 5) * 2).clamp(28, 36), // 28 -> 36
          timeSeconds: (6 - (localLevel ~/ 20)).clamp(3, 6), // 6 -> 3
          colorDeltaMin: (15.0 - (localLevel * 0.1)).clamp(8.0, 15.0),
          shapeDeltaMin: (0.08 - (localLevel * 0.0005)).clamp(0.04, 0.08),
          allowMultiAttribute: true,
          useMisdirection: true,
        );
    }
  }

  static DifficultyTier _getTier(int level) {
    if (level <= 10) return DifficultyTier.beginner;
    if (level <= 30) return DifficultyTier.intermediate;
    if (level <= 70) return DifficultyTier.advanced;
    return DifficultyTier.expert;
  }

  int getGridColumns() {
    if (gridSize <= 4) return 2;
    if (gridSize <= 9) return 3;
    if (gridSize <= 16) return 4;
    if (gridSize <= 25) return 5;
    return 6;
  }
}
