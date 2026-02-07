import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';

/// Provider for game controller
final gameControllerProvider = StateNotifierProvider<GameController, GameState>(
  (ref) {
    return GameController();
  },
);

/// Main game controller - handles all game logic
/// UI is purely reactive - no game logic in widgets
class GameController extends StateNotifier<GameState> {
  final LevelGenerator _levelGenerator;
  final ScoreService _scoreService;
  final StorageService _storageService;

  Timer? _timer;
  bool _isTransitioning = false;

  GameController({
    LevelGenerator? levelGenerator,
    ScoreService? scoreService,
    StorageService? storageService,
  }) : _levelGenerator = levelGenerator ?? LevelGenerator(),
       _scoreService = scoreService ?? const ScoreService(),
       _storageService = storageService ?? StorageService(),
       super(const GameState());

  /// Starts a new game with given mode
  Future<void> startGame(GameMode mode) async {
    _cancelTimer();
    _isTransitioning = false;

    // Load high score
    final highScore = await _storageService.getHighScore(mode);

    state = GameState(
      status: GameStatus.playing,
      mode: mode,
      levelNumber: 1,
      score: 0,
      comboStreak: 0,
      highScore: highScore,
    );

    _startLevel();
  }

  /// Handles tile selection
  void selectTile(int index) {
    if (!mounted) return;
    if (state.status != GameStatus.playing) return;
    if (_isTransitioning) return;
    if (state.currentLevel == null) return;
    if (index < 0 || index >= state.currentLevel!.tiles.length) return;

    final tile = state.currentLevel!.tiles[index];
    state = state.copyWith(selectedTileIndex: index);

    if (tile.isOdd) {
      _onCorrectAnswer();
    } else {
      _onWrongAnswer();
    }
  }

  /// Restarts game with current mode
  void restartGame() {
    startGame(state.mode);
  }

  void _startLevel() {
    if (!mounted) return;

    final level = _levelGenerator.generate(
      levelNumber: state.levelNumber,
      mode: state.mode,
    );

    state = state.copyWith(
      currentLevel: level,
      timeRemaining: level.timeSeconds,
      selectedTileIndex: clearValue,
      status: GameStatus.playing,
    );

    _startTimer();
  }

  void _startTimer() {
    _cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (state.status != GameStatus.playing) {
        timer.cancel();
        return;
      }

      if (state.timeRemaining > 1) {
        state = state.copyWith(timeRemaining: state.timeRemaining - 1);
      } else {
        _gameOver();
      }
    });
  }

  void _onCorrectAnswer() {
    if (!mounted || _isTransitioning) return;

    _isTransitioning = true;
    _cancelTimer();

    // Calculate score
    final level = state.currentLevel!;
    final newCombo = state.comboStreak + 1;
    final levelScore = _scoreService.calculateScore(
      level: state.levelNumber,
      timeRemaining: state.timeRemaining,
      maxTime: level.timeSeconds,
      comboStreak: newCombo,
    );

    // Show correct feedback
    state = state.copyWith(
      status: GameStatus.correct,
      score: state.score + levelScore,
      comboStreak: newCombo,
    );

    // Transition to next level
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) {
        _isTransitioning = false;
        return;
      }

      state = state.copyWith(
        levelNumber: state.levelNumber + 1,
        selectedTileIndex: clearValue,
      );

      _startLevel();
      _isTransitioning = false;
    });
  }

  void _onWrongAnswer() {
    if (!mounted) return;

    final penalty = _scoreService.getTimePenalty(state.levelNumber);
    final newTime = (state.timeRemaining - penalty).clamp(0, 999);

    // Show wrong feedback
    state = state.copyWith(
      status: GameStatus.wrong,
      comboStreak: 0,
      timeRemaining: newTime,
    );

    if (newTime <= 0) {
      _gameOver();
      return;
    }

    // Clear selection and resume
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      if (state.status == GameStatus.wrong) {
        state = state.copyWith(
          status: GameStatus.playing,
          selectedTileIndex: clearValue,
        );
      }
    });
  }

  void _gameOver() {
    _cancelTimer();
    _isTransitioning = false;

    // Save high score
    final newHighScore =
        state.score > state.highScore ? state.score : state.highScore;
    _storageService.saveHighScore(state.score, state.mode);

    state = state.copyWith(
      status: GameStatus.gameOver,
      highScore: newHighScore,
    );
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
