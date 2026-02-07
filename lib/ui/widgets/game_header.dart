import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Game header showing level, score, time, and combo
class GameHeader extends StatelessWidget {
  final int level;
  final int score;
  final int timeRemaining;
  final int maxTime;
  final int comboStreak;
  final String modeName;

  const GameHeader({
    super.key,
    required this.level,
    required this.score,
    required this.timeRemaining,
    required this.maxTime,
    required this.comboStreak,
    required this.modeName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Top row: Mode and Level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                modeName.toUpperCase(),
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('LEVEL $level', style: AppTheme.headlineMedium),
            ],
          ),

          const SizedBox(height: 12),

          // Timer bar
          _TimerBar(timeRemaining: timeRemaining, maxTime: maxTime),

          const SizedBox(height: 12),

          // Bottom row: Score and Combo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(label: 'SCORE', value: score.toString()),
              if (comboStreak > 0) _ComboIndicator(streak: comboStreak),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerBar extends StatelessWidget {
  final int timeRemaining;
  final int maxTime;

  const _TimerBar({required this.timeRemaining, required this.maxTime});

  @override
  Widget build(BuildContext context) {
    final progress = maxTime > 0 ? timeRemaining / maxTime : 0.0;
    final isUrgent = progress < 0.3;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TIME', style: AppTheme.bodyMedium),
            Text(
              '$timeRemaining',
              style: AppTheme.headlineLarge.copyWith(
                color: isUrgent ? AppTheme.wrong : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.surfaceLight,
            valueColor: AlwaysStoppedAnimation(
              isUrgent ? AppTheme.wrong : AppTheme.primary,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.bodyMedium),
        Text(value, style: AppTheme.headlineLarge),
      ],
    );
  }
}

class _ComboIndicator extends StatelessWidget {
  final int streak;

  const _ComboIndicator({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.warning.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.warning),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: AppTheme.warning,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            '${streak}x',
            style: AppTheme.labelLarge.copyWith(color: AppTheme.warning),
          ),
        ],
      ),
    );
  }
}
