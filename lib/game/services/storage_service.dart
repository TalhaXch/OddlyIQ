import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_mode.dart';

/// Handles local storage for high scores
class StorageService {
  static const String _keyPrefix = 'oddlyiq_highscore_';

  Future<int> getHighScore(GameMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_keyPrefix${mode.name}') ?? 0;
  }

  Future<void> saveHighScore(int score, GameMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getHighScore(mode);
    if (score > current) {
      await prefs.setInt('$_keyPrefix${mode.name}', score);
    }
  }

  Future<Map<GameMode, int>> getAllHighScores() async {
    final results = <GameMode, int>{};
    for (final mode in GameMode.values) {
      results[mode] = await getHighScore(mode);
    }
    return results;
  }
}
