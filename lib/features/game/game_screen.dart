import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/controllers/game_controller.dart';
import '../../core/models/game_state.dart';
import '../../core/services/difficulty_service.dart';
import '../game_over/game_over_screen.dart';
import 'widgets/game_item_widget.dart';
import 'widgets/game_header.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);

    ref.listen<GameState>(gameControllerProvider, (previous, next) {
      if (next.status == GameStatus.gameOver) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const GameOverScreen()),
        );
      }
    });

    if (gameState.items.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final difficultyService = DifficultyService();
    final gridColumns = difficultyService.getGridColumns(
      gameState.items.length,
    );
    final config = difficultyService.getConfigForLevel(gameState.currentLevel);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing),
          child: Column(
            children: [
              GameHeader(
                level: gameState.currentLevel,
                score: gameState.score,
                timeRemaining: gameState.timeRemaining,
                comboStreak: gameState.comboStreak,
                maxTime: config.timeLimitSeconds,
              ),

              const SizedBox(height: AppConstants.spacingLarge),

              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridColumns,
                        crossAxisSpacing: AppConstants.spacing,
                        mainAxisSpacing: AppConstants.spacing,
                      ),
                      itemCount: gameState.items.length,
                      itemBuilder: (context, index) {
                        final item = gameState.items[index];
                        final isSelected = gameState.selectedItemIndex == index;

                        return GameItemWidget(
                          item: item,
                          isSelected: isSelected,
                          onTap: () {
                            ref
                                .read(gameControllerProvider.notifier)
                                .selectItem(index);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.spacingLarge),
            ],
          ),
        ),
      ),
    );
  }
}
