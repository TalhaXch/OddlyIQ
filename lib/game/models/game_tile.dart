import 'package:flutter/material.dart';

/// Visual type for rendering - enforces standardization rules
enum TileVisualType {
  /// Standardized square - used for color-only differentiation
  /// No shape variation, rotation, or aspect ratio changes allowed
  squareColor,

  /// Shape tile - allows geometric variations
  /// Color must remain constant
  shape,
}

/// Immutable game tile representation
class GameTile {
  final String id;
  final bool isOdd;
  final TileVisualType visualType;
  final Color color;
  final double cornerRadius;
  final double strokeWidth;
  final double rotation;
  final double aspectRatio;

  const GameTile({
    required this.id,
    required this.isOdd,
    required this.visualType,
    required this.color,
    this.cornerRadius = 8.0,
    this.strokeWidth = 0.0,
    this.rotation = 0.0,
    this.aspectRatio = 1.0,
  });

  /// Create a square color tile (standardized)
  factory GameTile.squareColor({
    required String id,
    required bool isOdd,
    required Color color,
  }) {
    return GameTile(
      id: id,
      isOdd: isOdd,
      visualType: TileVisualType.squareColor,
      color: color,
      cornerRadius: 8.0,
      strokeWidth: 0.0,
      rotation: 0.0,
      aspectRatio: 1.0,
    );
  }

  /// Create a shape tile with geometric variations
  factory GameTile.shape({
    required String id,
    required bool isOdd,
    required Color color,
    required double cornerRadius,
    double strokeWidth = 0.0,
    double rotation = 0.0,
    double aspectRatio = 1.0,
  }) {
    return GameTile(
      id: id,
      isOdd: isOdd,
      visualType: TileVisualType.shape,
      color: color,
      cornerRadius: cornerRadius,
      strokeWidth: strokeWidth,
      rotation: rotation,
      aspectRatio: aspectRatio,
    );
  }

  GameTile copyWith({
    String? id,
    bool? isOdd,
    TileVisualType? visualType,
    Color? color,
    double? cornerRadius,
    double? strokeWidth,
    double? rotation,
    double? aspectRatio,
  }) {
    return GameTile(
      id: id ?? this.id,
      isOdd: isOdd ?? this.isOdd,
      visualType: visualType ?? this.visualType,
      color: color ?? this.color,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      rotation: rotation ?? this.rotation,
      aspectRatio: aspectRatio ?? this.aspectRatio,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameTile && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
