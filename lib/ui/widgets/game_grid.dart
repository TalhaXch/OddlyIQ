import 'package:flutter/material.dart';
import '../../core/config/game_config.dart';
import '../../game/models/models.dart';
import 'tile_widget.dart';

/// Renders the game grid with tiles
class GameGrid extends StatelessWidget {
  final GameLevel level;
  final int? selectedIndex;
  final bool showResult;
  final ValueChanged<int>? onTileTap;

  const GameGrid({
    super.key,
    required this.level,
    this.selectedIndex,
    this.showResult = false,
    this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        key: ValueKey('grid_${level.levelNumber}'),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: level.gridColumns,
          crossAxisSpacing: GameConfig.gridSpacing,
          mainAxisSpacing: GameConfig.gridSpacing,
        ),
        itemCount: level.tiles.length,
        itemBuilder: (context, index) {
          final tile = level.tiles[index];
          final isSelected = selectedIndex == index;

          return AnimatedTileWidget(
            key: ValueKey('tile_${level.levelNumber}_$index'),
            tile: tile,
            isSelected: isSelected,
            showResult: showResult,
            onTap: onTileTap != null ? () => onTileTap!(index) : null,
          );
        },
      ),
    );
  }
}
