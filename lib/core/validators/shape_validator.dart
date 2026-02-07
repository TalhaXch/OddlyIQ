import '../../game/models/game_tile.dart';

/// Validates shape differences using geometric properties
/// Ensures shapes are perceptually distinguishable
class ShapeValidator {
  const ShapeValidator();

  /// Shape properties that can differ
  static const double minCornerRadiusDelta = 4.0;
  static const double minStrokeWidthDelta = 1.5;
  static const double minRotationDelta = 15.0; // degrees
  static const double minAspectRatioDelta = 0.15;

  /// Calculates the perceptual delta between two shapes
  /// Returns normalized delta (0.0 - 1.0+)
  double calculateDelta(GameTile a, GameTile b) {
    double totalDelta = 0.0;

    // Corner radius contribution
    final cornerDelta =
        (a.cornerRadius - b.cornerRadius).abs() / minCornerRadiusDelta;
    totalDelta += cornerDelta * 0.3;

    // Stroke width contribution
    final strokeDelta =
        (a.strokeWidth - b.strokeWidth).abs() / minStrokeWidthDelta;
    totalDelta += strokeDelta * 0.2;

    // Rotation contribution (normalized to 0-180)
    double rotDiff = (a.rotation - b.rotation).abs() % 180;
    if (rotDiff > 90) rotDiff = 180 - rotDiff;
    final rotDelta = rotDiff / minRotationDelta;
    totalDelta += rotDelta * 0.25;

    // Aspect ratio contribution
    final aspectDelta =
        (a.aspectRatio - b.aspectRatio).abs() / minAspectRatioDelta;
    totalDelta += aspectDelta * 0.25;

    return totalDelta;
  }

  /// Validates that two shapes meet minimum perceptual threshold
  bool isDistinguishable(GameTile a, GameTile b, double minDelta) {
    return calculateDelta(a, b) >= minDelta;
  }

  /// Validates shape set - odd must differ from normals
  bool validateShapeSet({
    required GameTile oddTile,
    required GameTile normalTile,
    required double minDelta,
  }) {
    return isDistinguishable(oddTile, normalTile, minDelta);
  }

  /// Generates shape properties that differ by at least minDelta
  ({
    double cornerRadius,
    double strokeWidth,
    double rotation,
    double aspectRatio,
  })
  generateDistinctProperties({
    required double baseCornerRadius,
    required double baseStrokeWidth,
    required double baseRotation,
    required double baseAspectRatio,
    required double minDelta,
  }) {
    // Decide which property to vary based on delta requirement
    if (minDelta >= 0.3) {
      // Large delta - vary multiple properties
      return (
        cornerRadius: baseCornerRadius + minCornerRadiusDelta * 2,
        strokeWidth: baseStrokeWidth + minStrokeWidthDelta,
        rotation: baseRotation + minRotationDelta * 2,
        aspectRatio: baseAspectRatio + minAspectRatioDelta,
      );
    } else if (minDelta >= 0.15) {
      // Medium delta - vary corner radius and rotation
      return (
        cornerRadius: baseCornerRadius + minCornerRadiusDelta * 1.5,
        strokeWidth: baseStrokeWidth,
        rotation: baseRotation + minRotationDelta,
        aspectRatio: baseAspectRatio,
      );
    } else {
      // Small delta - subtle corner radius change
      return (
        cornerRadius: baseCornerRadius + minCornerRadiusDelta,
        strokeWidth: baseStrokeWidth,
        rotation: baseRotation,
        aspectRatio: baseAspectRatio,
      );
    }
  }
}
