import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/game_config.dart';
import '../../game/models/game_mode.dart';
import '../../game/controllers/game_controller.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';

class ModeSelectionScreen extends ConsumerStatefulWidget {
  const ModeSelectionScreen({super.key});

  @override
  ConsumerState<ModeSelectionScreen> createState() =>
      _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends ConsumerState<ModeSelectionScreen>
    with TickerProviderStateMixin {
  GameMode _selectedMode = GameMode.classic;
  late AnimationController _gradientController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startGame() {
    ref.read(gameControllerProvider.notifier).startGame(_selectedMode);
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const GameScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(
                      math.cos(_gradientController.value * 2 * math.pi) * 0.8,
                      math.sin(_gradientController.value * 2 * math.pi) * 0.8,
                    ),
                    end: Alignment(
                      math.cos(
                            (_gradientController.value + 0.5) * 2 * math.pi,
                          ) *
                          0.8,
                      math.sin(
                            (_gradientController.value + 0.5) * 2 * math.pi,
                          ) *
                          0.8,
                    ),
                    colors: const [
                      Color(0xFF0A0A0F),
                      Color(0xFF0D0A18),
                      Color(0xFF150A1E),
                      Color(0xFF0A0A0F),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              );
            },
          ),

          // Floating orbs
          Positioned(
            top: 50,
            right: -60,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.accent.withValues(
                          alpha: 0.1 * _pulseAnimation.value,
                        ),
                        AppTheme.accent.withValues(
                          alpha: 0.03 * _pulseAnimation.value,
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            bottom: 100,
            left: -80,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.secondary.withValues(
                          alpha: 0.08 * _pulseAnimation.value,
                        ),
                        AppTheme.secondary.withValues(
                          alpha: 0.02 * _pulseAnimation.value,
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Floating particles
          const _ModeParticles(),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom app bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.surface.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.surfaceLight.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: const Icon(Icons.arrow_back, size: 20),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      ShaderMask(
                        shaderCallback:
                            (bounds) => const LinearGradient(
                              colors: [AppTheme.textPrimary, AppTheme.primary],
                            ).createShader(bounds),
                        child: const Text(
                          'SELECT MODE',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GameConfig.screenPadding,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surface.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Choose your challenge',
                      style: AppTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Mode cards
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: GameConfig.screenPadding,
                    ),
                    child: ListView.separated(
                      itemCount: GameMode.values.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final mode = GameMode.values[index];
                        final isSelected = _selectedMode == mode;
                        return _EnhancedModeCard(
                          title: mode.displayName,
                          description: mode.description,
                          icon: mode.icon,
                          isSelected: isSelected,
                          onTap: () => setState(() => _selectedMode = mode),
                        );
                      },
                    ),
                  ),
                ),

                // Start button
                Padding(
                  padding: const EdgeInsets.all(GameConfig.screenPadding),
                  child: _GlowingStartButton(
                    label: 'START ${_selectedMode.displayName.toUpperCase()}',
                    onPressed: _startGame,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Floating particles for mode screen
class _ModeParticles extends StatefulWidget {
  const _ModeParticles();

  @override
  State<_ModeParticles> createState() => _ModeParticlesState();
}

class _ModeParticlesState extends State<_ModeParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    final random = math.Random();
    _particles = List.generate(
      15,
      (index) => _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2.5 + 0.5,
        speed: random.nextDouble() * 0.2 + 0.05,
        opacity: random.nextDouble() * 0.3 + 0.1,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(
            particles: _particles,
            animationValue: _controller.value,
            color: AppTheme.accent,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double animationValue;
  final Color color;

  _ParticlePainter({
    required this.particles,
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final y = (particle.y + animationValue * particle.speed) % 1.0;
      final paint =
          Paint()
            ..color = color.withValues(alpha: particle.opacity)
            ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x * size.width, y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

// Enhanced mode card with glow effect
class _EnhancedModeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _EnhancedModeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary.withValues(alpha: 0.2),
                      AppTheme.secondary.withValues(alpha: 0.1),
                    ],
                  )
                  : null,
          color: isSelected ? null : AppTheme.surface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                isSelected
                    ? AppTheme.primary.withValues(alpha: 0.5)
                    : AppTheme.surfaceLight.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.2),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ]
                  : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? AppTheme.primary.withValues(alpha: 0.2)
                        : AppTheme.surfaceLight.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected
                              ? AppTheme.textPrimary
                              : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}

// Glowing start button
class _GlowingStartButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _GlowingStartButton({required this.label, required this.onPressed});

  @override
  State<_GlowingStartButton> createState() => _GlowingStartButtonState();
}

class _GlowingStartButtonState extends State<_GlowingStartButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.primary, AppTheme.secondary],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: _isPressed ? 0.6 : 0.4),
              blurRadius: _isPressed ? 20 : 15,
              spreadRadius: _isPressed ? 2 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        transform:
            _isPressed ? (Matrix4.identity()..scale(0.98)) : Matrix4.identity(),
        transformAlignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.play_arrow_rounded,
              color: AppTheme.textPrimary,
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
