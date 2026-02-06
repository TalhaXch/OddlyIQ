import 'package:flutter/material.dart';

enum ItemType { shape, color, icon, number, symbol }

enum ShapeType { circle, square, triangle, star, diamond, hexagon }

class GameItem {
  final String id;
  final ItemType type;
  final bool isOdd;
  final Color? color;
  final ShapeType? shape;
  final IconData? icon;
  final String? number;
  final String? symbol;
  final double rotation;
  final double scale;
  final double opacity;

  GameItem({
    required this.id,
    required this.type,
    required this.isOdd,
    this.color,
    this.shape,
    this.icon,
    this.number,
    this.symbol,
    this.rotation = 0.0,
    this.scale = 1.0,
    this.opacity = 1.0,
  });

  GameItem copyWith({
    bool? isOdd,
    Color? color,
    ShapeType? shape,
    IconData? icon,
    String? number,
    String? symbol,
    double? rotation,
    double? scale,
    double? opacity,
  }) {
    return GameItem(
      id: id,
      type: type,
      isOdd: isOdd ?? this.isOdd,
      color: color ?? this.color,
      shape: shape ?? this.shape,
      icon: icon ?? this.icon,
      number: number ?? this.number,
      symbol: symbol ?? this.symbol,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      opacity: opacity ?? this.opacity,
    );
  }
}
