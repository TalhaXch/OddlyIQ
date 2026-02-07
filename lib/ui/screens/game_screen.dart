import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/game_config.dart';
import '../../game/models/models.dart';
import '../../game/controllers/game_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'game_over_screen.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);

    // Listen for game over
    ref.listen<GameState>(gameControllerProvider, (previous, next) {
      if (next.status == GameStatus.gameOver) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GameOverScreen()),
        );
      }
    });

    // Loading state
    if (gameState.currentLevel == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final level = gameState.currentLevel!;
    final showResult =
        gameState.status == GameStatus.correct ||
        gameState.status == GameStatus.wrong;

    return Scaffold(
      body: Stack(
        children: [
          // Subtle animated gradient background
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      math.sin(_bgController.value * 2 * math.pi) * 0.5,
                      math.cos(_bgController.value * 2 * math.pi) * 0.5,
                    ),
                    radius: 1.5,
                    colors: const [Color(0xFF12121A), Color(0xFF0A0A0F)],
                  ),
                ),
              );
            },
          ),

          // Subtle corner glows based on game state
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (showResult && gameState.status == GameStatus.correct
                            ? AppTheme.correct
                            : AppTheme.primary)
                        .withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -100,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (showResult && gameState.status == GameStatus.wrong
                            ? AppTheme.wrong
                            : AppTheme.secondary)
                        .withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(GameConfig.screenPadding),
              child: Column(
                children: [
                  // Header
                  GameHeader(
                    level: gameState.levelNumber,
                    score: gameState.score,
                    timeRemaining: gameState.timeRemaining,
                    maxTime: level.timeSeconds,
                    comboStreak: gameState.comboStreak,
                    modeName: gameState.mode.displayName,
                  ),

                  const Spacer(),

                  // Game grid
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: GameGrid(
                        level: level,
                        selectedIndex: gameState.selectedTileIndex,
                        showResult: showResult,
                        onTileTap: (index) {
                          ref
                              .read(gameControllerProvider.notifier)
                              .selectTile(index);
                        },
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Instruction
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surface.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.surfaceLight.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'Find the odd one',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
