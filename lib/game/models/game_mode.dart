import 'package:flutter/material.dart';

/// Game mode definitions with strict differentiation rules
enum GameMode { classic, color, shape }

extension GameModeExtension on GameMode {
  String get displayName {
    switch (this) {
      case GameMode.classic:
        return 'Classic';
      case GameMode.color:
        return 'Color';
      case GameMode.shape:
        return 'Shape';
    }
  }

  String get description {
    switch (this) {
      case GameMode.classic:
        return 'Mixed challenges with progressive difficulty';
      case GameMode.color:
        return 'Pure color perception - standardized tiles';
      case GameMode.shape:
        return 'Geometric precision - subtle shape differences';
    }
  }

  IconData get icon {
    switch (this) {
      case GameMode.classic:
        return Icons.psychology;
      case GameMode.color:
        return Icons.palette;
      case GameMode.shape:
        return Icons.category;
    }
  }

  /// Whether this mode uses color as the ONLY differentiator
  bool get isColorOnly => this == GameMode.color;

  /// Whether this mode uses shape as the ONLY differentiator
  bool get isShapeOnly => this == GameMode.shape;

  /// Whether tiles must be standardized squares (color mode)
  bool get requiresSquareTiles => this == GameMode.color;
}
