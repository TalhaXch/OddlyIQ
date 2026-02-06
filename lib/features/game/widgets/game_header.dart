import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class GameHeader extends StatelessWidget {
  final int level;
  final int score;
  final int timeRemaining;
  final int comboStreak;
  final int maxTime;

  const GameHeader({
    super.key,
    required this.level,
    required this.score,
    required this.timeRemaining,
    required this.comboStreak,
    required this.maxTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatCard(
              label: 'LEVEL',
              value: level.toString(),
              color: AppTheme.primaryColor,
            ),
            _StatCard(
              label: 'SCORE',
              value: score.toString(),
              color: AppTheme.secondaryColor,
            ),
          ],
        ),

        const SizedBox(height: AppConstants.spacing),

        _TimerBar(timeRemaining: timeRemaining, maxTime: maxTime),

        if (comboStreak >= 3) ...[
          const SizedBox(height: AppConstants.spacing),
          _ComboIndicator(streak: comboStreak),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacing),
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingSmall / 2,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: [AppTheme.softShadow],
        ),
        child: Column(
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerBar extends StatelessWidget {
  final int timeRemaining;
  final int maxTime;

  const _TimerBar({required this.timeRemaining, required this.maxTime});

  Color get _timerColor {
    final percentage = timeRemaining / maxTime;
    if (percentage > 0.5) return AppTheme.correctColor;
    if (percentage > 0.25) return const Color(0xFFF59E0B);
    return AppTheme.wrongColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [AppTheme.softShadow],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TIME', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                '${timeRemaining}s',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: _timerColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (timeRemaining / maxTime).clamp(0.0, 1.0),
              backgroundColor: AppTheme.backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(_timerColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComboIndicator extends StatelessWidget {
  final int streak;

  const _ComboIndicator({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing,
        vertical: AppConstants.spacingSmall,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'COMBO x$streak',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
