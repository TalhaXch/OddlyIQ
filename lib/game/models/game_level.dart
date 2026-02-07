import 'game_mode.dart';
import 'game_tile.dart';
import '../../core/config/difficulty_config.dart';

/// Represents a single validated game level
class GameLevel {
  final int levelNumber;
  final GameMode mode;
  final DifficultyConfig difficulty;
  final List<GameTile> tiles;
  final int oddTileIndex;

  const GameLevel({
    required this.levelNumber,
    required this.mode,
    required this.difficulty,
    required this.tiles,
    required this.oddTileIndex,
  });

  /// Validates that exactly one odd tile exists at the expected index
  bool get isValid {
    if (tiles.isEmpty) return false;
    if (oddTileIndex < 0 || oddTileIndex >= tiles.length) return false;

    int oddCount = 0;
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i].isOdd) {
        oddCount++;
        if (i != oddTileIndex) return false;
      }
    }
    return oddCount == 1;
  }

  int get gridSize => tiles.length;
  int get gridColumns => difficulty.getGridColumns();
  int get timeSeconds => difficulty.timeSeconds;
}
