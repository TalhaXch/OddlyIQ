import 'game_mode.dart';
import 'game_level.dart';

/// Current game status
enum GameStatus { initial, playing, paused, correct, wrong, gameOver }

/// Sentinel for clearing nullable fields in copyWith
class _ClearValue {
  const _ClearValue();
}

const clearValue = _ClearValue();

/// Immutable game state
class GameState {
  final GameStatus status;
  final GameMode mode;
  final GameLevel? currentLevel;
  final int levelNumber;
  final int score;
  final int comboStreak;
  final int timeRemaining;
  final int? selectedTileIndex;
  final int highScore;

  const GameState({
    this.status = GameStatus.initial,
    this.mode = GameMode.classic,
    this.currentLevel,
    this.levelNumber = 0,
    this.score = 0,
    this.comboStreak = 0,
    this.timeRemaining = 0,
    this.selectedTileIndex,
    this.highScore = 0,
  });

  bool get isPlaying => status == GameStatus.playing;
  bool get isGameOver => status == GameStatus.gameOver;
  bool get hasSelection => selectedTileIndex != null;

  GameState copyWith({
    GameStatus? status,
    GameMode? mode,
    Object? currentLevel,
    int? levelNumber,
    int? score,
    int? comboStreak,
    int? timeRemaining,
    Object? selectedTileIndex,
    int? highScore,
  }) {
    return GameState(
      status: status ?? this.status,
      mode: mode ?? this.mode,
      currentLevel:
          currentLevel is _ClearValue
              ? null
              : (currentLevel as GameLevel?) ?? this.currentLevel,
      levelNumber: levelNumber ?? this.levelNumber,
      score: score ?? this.score,
      comboStreak: comboStreak ?? this.comboStreak,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      selectedTileIndex:
          selectedTileIndex is _ClearValue
              ? null
              : (selectedTileIndex as int?) ?? this.selectedTileIndex,
      highScore: highScore ?? this.highScore,
    );
  }

  @override
  String toString() =>
      'GameState(status: $status, level: $levelNumber, score: $score, time: $timeRemaining)';
}
