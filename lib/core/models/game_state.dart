import 'game_item.dart';

enum GameStatus { initial, playing, paused, gameOver }

class GameState {
  final GameStatus status;
  final int currentLevel;
  final int score;
  final int comboStreak;
  final int timeRemaining;
  final List<GameItem> items;
  final int? selectedItemIndex;
  final int highScore;

  GameState({
    this.status = GameStatus.initial,
    this.currentLevel = 1,
    this.score = 0,
    this.comboStreak = 0,
    this.timeRemaining = 0,
    this.items = const [],
    this.selectedItemIndex,
    this.highScore = 0,
  });

  GameState copyWith({
    GameStatus? status,
    int? currentLevel,
    int? score,
    int? comboStreak,
    int? timeRemaining,
    List<GameItem>? items,
    int? selectedItemIndex,
    int? highScore,
  }) {
    return GameState(
      status: status ?? this.status,
      currentLevel: currentLevel ?? this.currentLevel,
      score: score ?? this.score,
      comboStreak: comboStreak ?? this.comboStreak,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      items: items ?? this.items,
      selectedItemIndex: selectedItemIndex,
      highScore: highScore ?? this.highScore,
    );
  }
}
