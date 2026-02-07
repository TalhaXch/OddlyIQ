import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/game_config.dart';
import '../../game/controllers/game_controller.dart';
import '../../game/models/game_mode.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'home_screen.dart';
import 'game_screen.dart';

class GameOverScreen extends ConsumerWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final isNewHighScore =
        gameState.score >= gameState.highScore && gameState.score > 0;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(GameConfig.screenPadding),
          child: Column(
            children: [
              const Spacer(),

              // Game over title
              const Text('GAME OVER', style: AppTheme.displayMedium),
              const SizedBox(height: 8),
              Text(
                gameState.mode.displayName.toUpperCase(),
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.primary),
              ),

              const SizedBox(height: 40),

              // New high score badge
              if (isNewHighScore) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.warning),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: AppTheme.warning),
                      const SizedBox(width: 8),
                      Text(
                        'NEW HIGH SCORE!',
                        style: AppTheme.labelLarge.copyWith(
                          color: AppTheme.warning,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Stats card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _StatRow(
                      icon: Icons.emoji_events,
                      label: 'FINAL SCORE',
                      value: gameState.score.toString(),
                      valueColor: AppTheme.primary,
                      isLarge: true,
                    ),
                    const Divider(color: AppTheme.surfaceLight, height: 32),
                    _StatRow(
                      icon: Icons.layers,
                      label: 'LEVEL REACHED',
                      value: gameState.levelNumber.toString(),
                    ),
                    const SizedBox(height: 16),
                    _StatRow(
                      icon: Icons.workspace_premium,
                      label: 'HIGH SCORE',
                      value: gameState.highScore.toString(),
                      valueColor: AppTheme.warning,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Buttons
              PrimaryButton(
                label: 'PLAY AGAIN',
                icon: Icons.refresh,
                onPressed: () {
                  ref.read(gameControllerProvider.notifier).restartGame();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const GameScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'HOME',
                icon: Icons.home,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
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
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isLarge;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.textSecondary, size: 20),
        const SizedBox(width: 12),
        Text(label, style: AppTheme.bodyMedium),
        const Spacer(),
        Text(
          value,
          style:
              isLarge
                  ? AppTheme.displayMedium.copyWith(color: valueColor)
                  : AppTheme.headlineLarge.copyWith(color: valueColor),
        ),
      ],
    );
  }
}
