import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/config/difficulty_config.dart';
import '../../core/validators/validators.dart';
import '../models/models.dart';

/// Generates validated game levels
/// Ensures fairness through validation before returning
class LevelGenerator {
  final ColorValidator _colorValidator;
  final ShapeValidator _shapeValidator;
  final LevelValidator _levelValidator;
  final Random _random;

  static const int _maxGenerationAttempts = 10;

  LevelGenerator({
    ColorValidator? colorValidator,
    ShapeValidator? shapeValidator,
    LevelValidator? levelValidator,
    Random? random,
  }) : _colorValidator = colorValidator ?? const ColorValidator(),
       _shapeValidator = shapeValidator ?? const ShapeValidator(),
       _levelValidator = levelValidator ?? const LevelValidator(),
       _random = random ?? Random();

  /// Generates a validated level for the given parameters
  /// Will retry up to _maxGenerationAttempts times
  GameLevel generate({required int levelNumber, required GameMode mode}) {
    final difficulty = DifficultyConfig.fromLevel(levelNumber);

    for (int attempt = 0; attempt < _maxGenerationAttempts; attempt++) {
      final level = _generateLevel(levelNumber, mode, difficulty);
      final validation = _levelValidator.validate(level);

      if (validation.isValid) {
        return level;
      }
    }

    // Fallback: generate guaranteed valid level
    return _generateFallbackLevel(levelNumber, mode, difficulty);
  }

  GameLevel _generateLevel(
    int levelNumber,
    GameMode mode,
    DifficultyConfig difficulty,
  ) {
    switch (mode) {
      case GameMode.classic:
        return _generateClassicLevel(levelNumber, difficulty);
      case GameMode.color:
        return _generateColorLevel(levelNumber, difficulty);
      case GameMode.shape:
        return _generateShapeLevel(levelNumber, difficulty);
    }
  }

  GameLevel _generateClassicLevel(
    int levelNumber,
    DifficultyConfig difficulty,
  ) {
    // Alternate between color and shape based on level
    if (levelNumber % 2 == 1) {
      return _generateColorLevel(levelNumber, difficulty);
    } else {
      return _generateShapeLevel(levelNumber, difficulty);
    }
  }

  GameLevel _generateColorLevel(int levelNumber, DifficultyConfig difficulty) {
    final gridSize = difficulty.gridSize;
    final oddIndex = _random.nextInt(gridSize);

    // Generate base color
    final baseColor = _generateBaseColor();

    // Generate distinct odd color
    final oddColor = _colorValidator.createSubtleVariation(
      baseColor,
      difficulty.colorDeltaMin + 5, // Add buffer
    );

    // Create odd tile FIRST
    final oddTile = GameTile.squareColor(
      id: 'tile_$oddIndex',
      isOdd: true,
      color: oddColor,
    );

    // Create all tiles
    final tiles = List<GameTile>.generate(gridSize, (index) {
      if (index == oddIndex) return oddTile;
      return GameTile.squareColor(
        id: 'tile_$index',
        isOdd: false,
        color: baseColor,
      );
    });

    return GameLevel(
      levelNumber: levelNumber,
      mode: GameMode.color,
      difficulty: difficulty,
      tiles: tiles,
      oddTileIndex: oddIndex,
    );
  }

  GameLevel _generateShapeLevel(int levelNumber, DifficultyConfig difficulty) {
    final gridSize = difficulty.gridSize;
    final oddIndex = _random.nextInt(gridSize);

    // Use neutral color for shape mode
    final neutralColor = Colors.grey.shade600;

    // Generate base shape properties
    final baseCornerRadius = 8.0 + _random.nextDouble() * 12;
    final baseStrokeWidth = _random.nextDouble() * 2;
    final baseRotation = _random.nextDouble() * 15;
    final baseAspectRatio = 0.9 + _random.nextDouble() * 0.2;

    // Generate distinct odd shape properties
    final oddProps = _shapeValidator.generateDistinctProperties(
      baseCornerRadius: baseCornerRadius,
      baseStrokeWidth: baseStrokeWidth,
      baseRotation: baseRotation,
      baseAspectRatio: baseAspectRatio,
      minDelta: difficulty.shapeDeltaMin + 0.05, // Add buffer
    );

    // Create odd tile FIRST
    final oddTile = GameTile.shape(
      id: 'tile_$oddIndex',
      isOdd: true,
      color: neutralColor,
      cornerRadius: oddProps.cornerRadius,
      strokeWidth: oddProps.strokeWidth,
      rotation: oddProps.rotation,
      aspectRatio: oddProps.aspectRatio,
    );

    // Create all tiles
    final tiles = List<GameTile>.generate(gridSize, (index) {
      if (index == oddIndex) return oddTile;
      return GameTile.shape(
        id: 'tile_$index',
        isOdd: false,
        color: neutralColor,
        cornerRadius: baseCornerRadius,
        strokeWidth: baseStrokeWidth,
        rotation: baseRotation,
        aspectRatio: baseAspectRatio,
      );
    });

    return GameLevel(
      levelNumber: levelNumber,
      mode: GameMode.shape,
      difficulty: difficulty,
      tiles: tiles,
      oddTileIndex: oddIndex,
    );
  }

  GameLevel _generateFallbackLevel(
    int levelNumber,
    GameMode mode,
    DifficultyConfig difficulty,
  ) {
    // Generate a guaranteed valid level with high contrast
    final gridSize = difficulty.gridSize;
    final oddIndex = _random.nextInt(gridSize);

    if (mode == GameMode.shape) {
      final neutralColor = Colors.grey.shade600;
      final tiles = List<GameTile>.generate(gridSize, (index) {
        final isOdd = index == oddIndex;
        return GameTile.shape(
          id: 'tile_$index',
          isOdd: isOdd,
          color: neutralColor,
          cornerRadius: isOdd ? 24.0 : 8.0, // Very obvious difference
          strokeWidth: 0.0,
          rotation: isOdd ? 45.0 : 0.0,
          aspectRatio: 1.0,
        );
      });

      return GameLevel(
        levelNumber: levelNumber,
        mode: mode,
        difficulty: difficulty,
        tiles: tiles,
        oddTileIndex: oddIndex,
      );
    }

    // Color fallback
    final baseColor = Colors.blue.shade500;
    final oddColor = Colors.orange.shade500; // Obviously different
    final tiles = List<GameTile>.generate(gridSize, (index) {
      final isOdd = index == oddIndex;
      return GameTile.squareColor(
        id: 'tile_$index',
        isOdd: isOdd,
        color: isOdd ? oddColor : baseColor,
      );
    });

    return GameLevel(
      levelNumber: levelNumber,
      mode: mode,
      difficulty: difficulty,
      tiles: tiles,
      oddTileIndex: oddIndex,
    );
  }

  Color _generateBaseColor() {
    final hue = _random.nextDouble() * 360;
    final saturation = 0.5 + _random.nextDouble() * 0.4;
    final lightness = 0.4 + _random.nextDouble() * 0.2;

    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }
}
