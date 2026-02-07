import '../../game/models/models.dart';
import 'color_validator.dart';
import 'shape_validator.dart';

/// Validates entire game levels for fairness
/// Ensures exactly one odd tile with perceptible difference
class LevelValidator {
  final ColorValidator _colorValidator;
  final ShapeValidator _shapeValidator;

  const LevelValidator({
    ColorValidator colorValidator = const ColorValidator(),
    ShapeValidator shapeValidator = const ShapeValidator(),
  }) : _colorValidator = colorValidator,
       _shapeValidator = shapeValidator;

  /// Validates a complete level
  /// Returns validation result with details
  LevelValidationResult validate(GameLevel level) {
    // Check structural validity
    if (!level.isValid) {
      return LevelValidationResult.invalid(
        'Structural validation failed: invalid odd tile configuration',
      );
    }

    // Get odd and normal tiles
    final oddTile = level.tiles[level.oddTileIndex];
    final normalTile = level.tiles.firstWhere((t) => !t.isOdd);

    // Validate based on visual type
    switch (oddTile.visualType) {
      case TileVisualType.squareColor:
        return _validateColorLevel(level, oddTile, normalTile);
      case TileVisualType.shape:
        return _validateShapeLevel(level, oddTile, normalTile);
    }
  }

  LevelValidationResult _validateColorLevel(
    GameLevel level,
    GameTile oddTile,
    GameTile normalTile,
  ) {
    // Verify all tiles use squareColor type
    for (final tile in level.tiles) {
      if (tile.visualType != TileVisualType.squareColor) {
        return LevelValidationResult.invalid(
          'Color level contains non-square tiles',
        );
      }
    }

    // Verify color difference meets threshold
    final colorValid = _colorValidator.validateColorSet(
      oddColor: oddTile.color,
      normalColor: normalTile.color,
      minDelta: level.difficulty.colorDeltaMin,
    );

    if (!colorValid) {
      final delta = _colorValidator.calculateDelta(
        oddTile.color,
        normalTile.color,
      );
      return LevelValidationResult.invalid(
        'Color delta $delta below minimum ${level.difficulty.colorDeltaMin}',
      );
    }

    return LevelValidationResult.valid();
  }

  LevelValidationResult _validateShapeLevel(
    GameLevel level,
    GameTile oddTile,
    GameTile normalTile,
  ) {
    // Verify all tiles have same color (shape mode)
    if (level.mode.isShapeOnly) {
      for (final tile in level.tiles) {
        if (tile.color != normalTile.color) {
          if (!tile.isOdd) {
            return LevelValidationResult.invalid(
              'Shape level has inconsistent colors',
            );
          }
        }
      }
    }

    // Verify shape difference meets threshold
    final shapeValid = _shapeValidator.validateShapeSet(
      oddTile: oddTile,
      normalTile: normalTile,
      minDelta: level.difficulty.shapeDeltaMin,
    );

    if (!shapeValid) {
      final delta = _shapeValidator.calculateDelta(oddTile, normalTile);
      return LevelValidationResult.invalid(
        'Shape delta $delta below minimum ${level.difficulty.shapeDeltaMin}',
      );
    }

    return LevelValidationResult.valid();
  }
}

/// Result of level validation
class LevelValidationResult {
  final bool isValid;
  final String? reason;

  const LevelValidationResult._({required this.isValid, this.reason});

  factory LevelValidationResult.valid() =>
      const LevelValidationResult._(isValid: true);

  factory LevelValidationResult.invalid(String reason) =>
      LevelValidationResult._(isValid: false, reason: reason);
}
