import 'package:flutter/material.dart';

/// Validates color differences using HSL color space
/// Ensures colors are perceptually distinguishable
class ColorValidator {
  const ColorValidator();

  /// Calculates the perceptual delta between two colors
  /// Returns a value representing total color difference
  double calculateDelta(Color a, Color b) {
    final hslA = HSLColor.fromColor(a);
    final hslB = HSLColor.fromColor(b);

    // Calculate hue difference (circular)
    double hueDiff = (hslA.hue - hslB.hue).abs();
    if (hueDiff > 180) hueDiff = 360 - hueDiff;

    // Saturation and lightness differences
    final satDiff = (hslA.saturation - hslB.saturation).abs() * 100;
    final lightDiff = (hslA.lightness - hslB.lightness).abs() * 100;

    // Combined perceptual delta
    // Hue is weighted more heavily for saturated colors
    final satWeight = (hslA.saturation + hslB.saturation) / 2;
    return (hueDiff * satWeight) + satDiff + lightDiff;
  }

  /// Validates that two colors meet minimum perceptual threshold
  bool isDistinguishable(Color a, Color b, double minDelta) {
    return calculateDelta(a, b) >= minDelta;
  }

  /// Validates a list of colors - odd color must differ from all normals
  bool validateColorSet({
    required Color oddColor,
    required Color normalColor,
    required double minDelta,
  }) {
    return isDistinguishable(oddColor, normalColor, minDelta);
  }

  /// Generates a color that is guaranteed to differ by minDelta
  Color generateDistinctColor(Color baseColor, double minDelta) {
    final hsl = HSLColor.fromColor(baseColor);

    // Rotate hue by minimum required amount
    final hueShift = minDelta.clamp(30.0, 120.0);
    final newHue = (hsl.hue + hueShift) % 360;

    return hsl.withHue(newHue).toColor();
  }

  /// Creates a subtle variation that still meets threshold
  Color createSubtleVariation(Color baseColor, double targetDelta) {
    final hsl = HSLColor.fromColor(baseColor);

    // Calculate components to achieve target delta
    final hueShift = targetDelta * 0.6;
    final satShift = (targetDelta * 0.002).clamp(0.0, 0.15);
    final lightShift = (targetDelta * 0.002).clamp(0.0, 0.1);

    return HSLColor.fromAHSL(
      1.0,
      (hsl.hue + hueShift) % 360,
      (hsl.saturation + satShift).clamp(0.3, 1.0),
      (hsl.lightness + lightShift).clamp(0.2, 0.8),
    ).toColor();
  }
}
