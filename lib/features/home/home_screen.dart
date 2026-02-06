import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/controllers/game_controller.dart';
import '../game/game_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Spacer(),

                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [AppTheme.cardShadow],
                  ),
                  child: const Icon(
                    Icons.psychology,
                    size: 76,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                  AppConstants.appTagline,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 60),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(gameControllerProvider.notifier).startGame();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const GameScreen(),
                        ),
                      );
                    },
                    child: const Text('START GAME'),
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                    boxShadow: [AppTheme.softShadow],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'HIGH SCORE',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${gameState.highScore}',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(color: AppTheme.primaryColor),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Text(
                  'Find the odd one out before time runs out',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
