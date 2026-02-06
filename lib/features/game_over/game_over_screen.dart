import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/controllers/game_controller.dart';
import '../home/home_screen.dart';
import '../game/game_screen.dart';

class GameOverScreen extends ConsumerWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              Text(
                'GAME OVER',
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(color: AppTheme.wrongColor),
              ),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(AppConstants.spacingLarge),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  boxShadow: [AppTheme.cardShadow],
                ),
                child: Column(
                  children: [
                    Text(
                      'FINAL SCORE',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${gameState.score}',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Divider(color: AppTheme.backgroundColor),

                    const SizedBox(height: 24),

                    _StatRow(
                      label: 'Level Reached',
                      value: '${gameState.currentLevel}',
                    ),

                    const SizedBox(height: 12),

                    _StatRow(
                      label: 'Best Combo',
                      value: '${gameState.comboStreak}x',
                    ),

                    const SizedBox(height: 24),

                    if (gameState.score >= gameState.highScore) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacing,
                          vertical: AppConstants.spacingSmall,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.secondaryColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.emoji_events,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'NEW HIGH SCORE!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Best: ${gameState.highScore}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  ref.read(gameControllerProvider.notifier).restartGame();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const GameScreen()),
                  );
                },
                child: const Text('PLAY AGAIN'),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: Text(
                  'BACK TO HOME',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}
