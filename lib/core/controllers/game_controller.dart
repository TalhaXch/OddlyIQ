import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../models/game_level.dart';
import '../services/difficulty_service.dart';
import '../services/scoring_service.dart';
import '../services/level_generator_service.dart';
import '../services/storage_service.dart';

final gameControllerProvider = StateNotifierProvider<GameController, GameState>(
  (ref) {
    return GameController();
  },
);

class GameController extends StateNotifier<GameState> {
  final DifficultyService _difficultyService = DifficultyService();
  final ScoringService _scoringService = ScoringService();
  final LevelGeneratorService _levelGenerator = LevelGeneratorService();
  final StorageService _storageService = StorageService();

  Timer? _timer;

  GameController() : super(GameState()) {
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final highScore = await _storageService.getHighScore();
    state = state.copyWith(highScore: highScore);
  }

  void startGame() {
    state = GameState(
      status: GameStatus.playing,
      currentLevel: 1,
      score: 0,
      comboStreak: 0,
      highScore: state.highScore,
    );
    _startLevel();
  }

  void _startLevel() {
    final config = _difficultyService.getConfigForLevel(state.currentLevel);
    final itemType = _difficultyService.getItemTypeForLevel(state.currentLevel);

    final level = GameLevel(
      levelNumber: state.currentLevel,
      gridSize: config.gridSize,
      timeLimit: config.timeLimitSeconds,
      itemType: itemType,
      difficulty: config,
    );

    final items = _levelGenerator.generateLevel(level);

    state = state.copyWith(
      items: items,
      timeRemaining: config.timeLimitSeconds,
      selectedItemIndex: null,
    );

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemaining > 0) {
        state = state.copyWith(timeRemaining: state.timeRemaining - 1);
      } else {
        _gameOver();
      }
    });
  }

  void selectItem(int index) {
    if (state.status != GameStatus.playing) return;

    final selectedItem = state.items[index];
    state = state.copyWith(selectedItemIndex: index);

    if (selectedItem.isOdd) {
      _onCorrectAnswer();
    } else {
      _onWrongAnswer();
    }
  }

  void _onCorrectAnswer() {
    _timer?.cancel();

    final config = _difficultyService.getConfigForLevel(state.currentLevel);
    final newComboStreak = state.comboStreak + 1;
    final levelScore = _scoringService.calculateScore(
      level: state.currentLevel,
      timeRemaining: state.timeRemaining,
      comboStreak: newComboStreak,
      tier: config.tier,
    );

    final newScore = state.score + levelScore;

    Future.delayed(const Duration(milliseconds: 500), () {
      state = state.copyWith(
        score: newScore,
        comboStreak: newComboStreak,
        currentLevel: state.currentLevel + 1,
      );
      _startLevel();
    });
  }

  void _onWrongAnswer() {
    final timePenalty = _scoringService.getTimePenalty(state.currentLevel);
    final newTimeRemaining = (state.timeRemaining - timePenalty).clamp(0, 9999);

    state = state.copyWith(
      comboStreak: 0,
      timeRemaining: newTimeRemaining,
      selectedItemIndex: state.selectedItemIndex,
    );

    if (newTimeRemaining <= 0) {
      _gameOver();
      return;
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      if (state.status == GameStatus.playing) {
        state = state.copyWith(selectedItemIndex: null);
      }
    });
  }

  void _gameOver() {
    _timer?.cancel();
    _storageService.saveHighScore(state.score);

    state = state.copyWith(
      status: GameStatus.gameOver,
      highScore: state.score > state.highScore ? state.score : state.highScore,
    );
  }

  void restartGame() {
    _timer?.cancel();
    startGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
