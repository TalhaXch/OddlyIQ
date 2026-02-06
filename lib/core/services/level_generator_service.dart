import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_item.dart';
import '../models/game_level.dart';

class LevelGeneratorService {
  final Random _random = Random();

  List<GameItem> generateLevel(GameLevel level) {
    switch (level.itemType) {
      case ItemType.shape:
        return _generateShapeLevel(level);
      case ItemType.color:
        return _generateColorLevel(level);
      case ItemType.icon:
        return _generateIconLevel(level);
      case ItemType.number:
        return _generateNumberLevel(level);
      case ItemType.symbol:
        return _generateSymbolLevel(level);
    }
  }

  List<GameItem> _generateShapeLevel(GameLevel level) {
    final shapes = ShapeType.values;
    final normalShape = shapes[_random.nextInt(shapes.length)];
    final oddShape = shapes.firstWhere(
      (s) => s != normalShape,
      orElse:
          () =>
              shapes[(_random.nextInt(shapes.length - 1) + 1) % shapes.length],
    );

    final color = _getBaseColor(level);
    final oddIndex = _random.nextInt(level.gridSize);

    return List.generate(level.gridSize, (index) {
      final isOdd = index == oddIndex;
      final itemColor = _applyColorVariation(color, level, isOdd);
      final rotation = _getRotation(level, isOdd);
      final scale = _getScale(level, isOdd);
      final opacity = _getOpacity(level, isOdd);

      return GameItem(
        id: 'item_$index',
        type: ItemType.shape,
        isOdd: isOdd,
        shape: isOdd ? oddShape : normalShape,
        color: itemColor,
        rotation: rotation,
        scale: scale,
        opacity: opacity,
      );
    });
  }

  List<GameItem> _generateColorLevel(GameLevel level) {
    final baseColor = _getBaseColor(level);
    final shape = ShapeType.circle;
    final oddIndex = _random.nextInt(level.gridSize);

    Color normalColor;
    Color oddColor;

    if (level.difficulty.useSubtleColors) {
      normalColor = baseColor;
      oddColor = _getSubtleColorVariation(baseColor, level);
    } else {
      normalColor = baseColor;
      oddColor = _getRandomColor(exclude: baseColor);
    }

    return List.generate(level.gridSize, (index) {
      final isOdd = index == oddIndex;
      final rotation = _getRotation(level, isOdd);
      final scale = _getScale(level, isOdd);
      final opacity = _getOpacity(level, isOdd);

      return GameItem(
        id: 'item_$index',
        type: ItemType.color,
        isOdd: isOdd,
        color: isOdd ? oddColor : normalColor,
        shape: shape,
        rotation: rotation,
        scale: scale,
        opacity: opacity,
      );
    });
  }

  List<GameItem> _generateIconLevel(GameLevel level) {
    final icons = [
      Icons.favorite,
      Icons.star,
      Icons.home,
      Icons.settings,
      Icons.person,
      Icons.music_note,
      Icons.phone,
      Icons.mail,
      Icons.lightbulb,
      Icons.shopping_cart,
      Icons.camera,
      Icons.bookmark,
    ];

    final normalIcon = icons[_random.nextInt(icons.length)];
    final oddIcon = icons.firstWhere(
      (i) => i != normalIcon,
      orElse:
          () => icons[(_random.nextInt(icons.length - 1) + 1) % icons.length],
    );

    final color = _getBaseColor(level);
    final oddIndex = _random.nextInt(level.gridSize);

    return List.generate(level.gridSize, (index) {
      final isOdd = index == oddIndex;
      final itemColor = _applyColorVariation(color, level, isOdd);
      final rotation = _getRotation(level, isOdd);
      final scale = _getScale(level, isOdd);
      final opacity = _getOpacity(level, isOdd);

      return GameItem(
        id: 'item_$index',
        type: ItemType.icon,
        isOdd: isOdd,
        icon: isOdd ? oddIcon : normalIcon,
        color: itemColor,
        rotation: rotation,
        scale: scale,
        opacity: opacity,
      );
    });
  }

  List<GameItem> _generateNumberLevel(GameLevel level) {
    final numbers = List.generate(9, (i) => (i + 1).toString());
    final normalNumber = numbers[_random.nextInt(numbers.length)];
    final oddNumber = numbers.firstWhere(
      (n) => n != normalNumber,
      orElse:
          () =>
              numbers[(_random.nextInt(numbers.length - 1) + 1) %
                  numbers.length],
    );

    final color = _getBaseColor(level);
    final oddIndex = _random.nextInt(level.gridSize);

    return List.generate(level.gridSize, (index) {
      final isOdd = index == oddIndex;
      final itemColor = _applyColorVariation(color, level, isOdd);
      final rotation = _getRotation(level, isOdd);
      final scale = _getScale(level, isOdd);
      final opacity = _getOpacity(level, isOdd);

      return GameItem(
        id: 'item_$index',
        type: ItemType.number,
        isOdd: isOdd,
        number: isOdd ? oddNumber : normalNumber,
        color: itemColor,
        rotation: rotation,
        scale: scale,
        opacity: opacity,
      );
    });
  }

  List<GameItem> _generateSymbolLevel(GameLevel level) {
    final symbols = [
      '★',
      '●',
      '■',
      '▲',
      '♦',
      '♥',
      '♠',
      '♣',
      '◆',
      '▼',
      '◀',
      '▶',
    ];
    final normalSymbol = symbols[_random.nextInt(symbols.length)];
    final oddSymbol = symbols.firstWhere(
      (s) => s != normalSymbol,
      orElse:
          () =>
              symbols[(_random.nextInt(symbols.length - 1) + 1) %
                  symbols.length],
    );

    final color = _getBaseColor(level);
    final oddIndex = _random.nextInt(level.gridSize);

    return List.generate(level.gridSize, (index) {
      final isOdd = index == oddIndex;
      final itemColor = _applyColorVariation(color, level, isOdd);
      final rotation = _getRotation(level, isOdd);
      final scale = _getScale(level, isOdd);
      final opacity = _getOpacity(level, isOdd);

      return GameItem(
        id: 'item_$index',
        type: ItemType.symbol,
        isOdd: isOdd,
        symbol: isOdd ? oddSymbol : normalSymbol,
        color: itemColor,
        rotation: rotation,
        scale: scale,
        opacity: opacity,
      );
    });
  }

  Color _getBaseColor(GameLevel level) {
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFF14B8A6),
      const Color(0xFFEF4444),
      const Color(0xFF3B82F6),
    ];
    return colors[_random.nextInt(colors.length)];
  }

  Color _applyColorVariation(Color base, GameLevel level, bool isOdd) {
    if (!level.difficulty.useMultiAttribute) return base;
    if (!isOdd || level.difficulty.attributeDiffCount < 2) return base;

    return _getSubtleColorVariation(base, level);
  }

  Color _getSubtleColorVariation(Color base, GameLevel level) {
    final hsl = HSLColor.fromColor(base);
    final intensity = level.difficulty.visualDifferenceIntensity;

    final hueShift = (_random.nextDouble() - 0.5) * 0.15 * intensity;
    final satShift = (_random.nextDouble() - 0.5) * 0.3 * intensity;
    final lightShift = (_random.nextDouble() - 0.5) * 0.3 * intensity;

    return hsl
        .withHue((hsl.hue + hueShift * 360) % 360)
        .withSaturation((hsl.saturation + satShift).clamp(0.0, 1.0))
        .withLightness((hsl.lightness + lightShift).clamp(0.0, 1.0))
        .toColor();
  }

  Color _getRandomColor({Color? exclude}) {
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFF14B8A6),
      const Color(0xFFEF4444),
      const Color(0xFF3B82F6),
    ];

    if (exclude != null) {
      colors.removeWhere((c) => c.value == exclude.value);
    }

    return colors[_random.nextInt(colors.length)];
  }

  double _getRotation(GameLevel level, bool isOdd) {
    if (!level.difficulty.useMicroDifferences) return 0.0;

    if (level.difficulty.usePatternMisdirection) {
      if (isOdd) {
        return 0.0;
      } else {
        return (_random.nextDouble() - 0.5) *
            level.difficulty.rotationVariance *
            2;
      }
    }

    final baseRotation =
        level.difficulty.usePatternMisdirection
            ? (_random.nextDouble() - 0.5) * 2.0
            : 0.0;

    if (isOdd && level.difficulty.attributeDiffCount >= 2) {
      return baseRotation +
          (_random.nextDouble() - 0.5) * level.difficulty.rotationVariance;
    }

    return baseRotation;
  }

  double _getScale(GameLevel level, bool isOdd) {
    if (!level.difficulty.useMicroDifferences) return 1.0;

    if (level.difficulty.usePatternMisdirection) {
      if (isOdd) {
        return 1.0;
      } else {
        return 1.0 +
            (_random.nextDouble() - 0.5) * level.difficulty.sizeVariance * 2;
      }
    }

    final baseScale = 1.0;

    if (isOdd &&
        (level.difficulty.attributeDiffCount >= 2 ||
            level.difficulty.tier == DifficultyTier.expert)) {
      return baseScale +
          (_random.nextDouble() - 0.5) * level.difficulty.sizeVariance;
    }

    return baseScale;
  }

  double _getOpacity(GameLevel level, bool isOdd) {
    if (!level.difficulty.useMicroDifferences) return 1.0;

    final baseOpacity = 1.0;

    if (level.difficulty.usePatternMisdirection) {
      if (!isOdd) {
        return baseOpacity -
            _random.nextDouble() * level.difficulty.opacityVariance;
      }
    }

    if (isOdd && level.difficulty.attributeDiffCount >= 3) {
      return baseOpacity -
          _random.nextDouble() * level.difficulty.opacityVariance;
    }

    return baseOpacity;
  }
}
