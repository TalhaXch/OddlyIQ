import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../game/models/game_tile.dart';
import '../theme/app_theme.dart';

/// Renders a single game tile
/// Handles both square color tiles and shape tiles
class TileWidget extends StatelessWidget {
  final GameTile tile;
  final bool isSelected;
  final bool showResult;
  final VoidCallback? onTap;

  const TileWidget({
    super.key,
    required this.tile,
    this.isSelected = false,
    this.showResult = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSelected ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getBorderColor(),
            width: isSelected ? 3 : 0,
          ),
        ),
        child: _buildTileContent(),
      ),
    );
  }

  Color _getBorderColor() {
    if (!showResult || !isSelected) return Colors.transparent;
    return tile.isOdd ? AppTheme.correct : AppTheme.wrong;
  }

  Widget _buildTileContent() {
    switch (tile.visualType) {
      case TileVisualType.squareColor:
        return _buildSquareColorTile();
      case TileVisualType.shape:
        return _buildShapeTile();
    }
  }

  /// Square color tile - standardized, only color differs
  Widget _buildSquareColorTile() {
    return Container(
      decoration: BoxDecoration(
        color: tile.color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  /// Shape tile - geometric variations allowed
  Widget _buildShapeTile() {
    return Transform.rotate(
      angle: tile.rotation * math.pi / 180,
      child: FractionallySizedBox(
        widthFactor: tile.aspectRatio < 1 ? tile.aspectRatio : 1.0,
        heightFactor: tile.aspectRatio > 1 ? 1 / tile.aspectRatio : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: tile.strokeWidth > 0 ? Colors.transparent : tile.color,
            borderRadius: BorderRadius.circular(tile.cornerRadius),
            border:
                tile.strokeWidth > 0
                    ? Border.all(color: tile.color, width: tile.strokeWidth)
                    : null,
          ),
        ),
      ),
    );
  }
}

/// Animated tile with feedback
class AnimatedTileWidget extends StatefulWidget {
  final GameTile tile;
  final bool isSelected;
  final bool showResult;
  final VoidCallback? onTap;

  const AnimatedTileWidget({
    super.key,
    required this.tile,
    this.isSelected = false,
    this.showResult = false,
    this.onTap,
  });

  @override
  State<AnimatedTileWidget> createState() => _AnimatedTileWidgetState();
}

class _AnimatedTileWidgetState extends State<AnimatedTileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(AnimatedTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: TileWidget(
        tile: widget.tile,
        isSelected: widget.isSelected,
        showResult: widget.showResult,
        onTap: widget.onTap,
      ),
    );
  }
}
