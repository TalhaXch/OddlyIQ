import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/game_config.dart';
import '../../game/models/game_mode.dart';
import '../../game/services/storage_service.dart';
import '../theme/app_theme.dart';
import 'mode_selection_screen.dart';
import 'game_screen.dart';
import '../../game/controllers/game_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  final StorageService _storageService = StorageService();
  Map<GameMode, int> _highScores = {};

  late AnimationController _gradientController;
  late AnimationController _pulseController;
  late AnimationController _entranceController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _loadHighScores();
    _initAnimations();
  }

  void _initAnimations() {
    // Gradient animation - slow continuous rotation
    _gradientController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    // Pulse animation for logo glow
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Entrance animation
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _pulseController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _loadHighScores() async {
    final scores = await _storageService.getAllHighScores();
    if (mounted) {
      setState(() => _highScores = scores);
    }
  }

  void _startQuickPlay() {
    ref.read(gameControllerProvider.notifier).startGame(GameMode.classic);
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const GameScreen()));
  }

  void _openModeSelection() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ModeSelectionScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final bestScore = _highScores.values.fold<int>(
      0,
      (max, score) => score > max ? score : max,
    );

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
                      math.cos(_gradientController.value * 2 * math.pi),
                      math.sin(_gradientController.value * 2 * math.pi),
                    ),
                    end: Alignment(
                      math.cos((_gradientController.value + 0.5) * 2 * math.pi),
                      math.sin((_gradientController.value + 0.5) * 2 * math.pi),
                    ),
                    colors: const [
                      Color(0xFF0A0A0F),
                      Color(0xFF0F0A1A),
                      Color(0xFF1A0A2E),
                      Color(0xFF0A0A0F),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              );
            },
          ),

          // Floating particles
          const _FloatingParticles(),

          // Mesh gradient orbs
          Positioned(
            top: -100,
            right: -100,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.primary.withOpacity(
                          0.15 * _pulseAnimation.value,
                        ),
                        AppTheme.primary.withOpacity(
                          0.05 * _pulseAnimation.value,
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
            bottom: -150,
            left: -100,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.secondary.withOpacity(
                          0.12 * _pulseAnimation.value,
                        ),
                        AppTheme.secondary.withOpacity(
                          0.04 * _pulseAnimation.value,
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeInAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(GameConfig.screenPadding),
                  child: Column(
                    children: [
                      const Spacer(),

                      // Animated glowing logo
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.primary.withOpacity(0.2),
                                  AppTheme.secondary.withOpacity(0.15),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: AppTheme.primary.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withOpacity(
                                    0.3 * _pulseAnimation.value,
                                  ),
                                  blurRadius: 30 * _pulseAnimation.value,
                                  spreadRadius: 5 * _pulseAnimation.value,
                                ),
                                BoxShadow(
                                  color: AppTheme.secondary.withOpacity(
                                    0.2 * _pulseAnimation.value,
                                  ),
                                  blurRadius: 50 * _pulseAnimation.value,
                                  spreadRadius: 10 * _pulseAnimation.value,
                                ),
                              ],
                            ),
                            child: ShaderMask(
                              shaderCallback:
                                  (bounds) => const LinearGradient(
                                    colors: [AppTheme.primary, AppTheme.accent],
                                  ).createShader(bounds),
                              child: const Icon(
                                Icons.psychology,
                                size: 64,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Gradient title
                      ShaderMask(
                        shaderCallback:
                            (bounds) => const LinearGradient(
                              colors: [
                                AppTheme.textPrimary,
                                AppTheme.primary,
                                AppTheme.accent,
                              ],
                            ).createShader(bounds),
                        child: const Text(
                          GameConfig.appName,
                          style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surface.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.surfaceLight.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          GameConfig.tagline,
                          style: AppTheme.bodyMedium.copyWith(
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // High score with glow
                      if (bestScore > 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.surface.withOpacity(0.8),
                                AppTheme.surfaceLight.withOpacity(0.4),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.warning.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.warning.withOpacity(0.15),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.warning.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.emoji_events,
                                  color: AppTheme.warning,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BEST SCORE',
                                    style: AppTheme.bodyMedium.copyWith(
                                      letterSpacing: 2,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  ShaderMask(
                                    shaderCallback:
                                        (bounds) => const LinearGradient(
                                          colors: [
                                            AppTheme.warning,
                                            Color(0xFFFFD700),
                                          ],
                                        ).createShader(bounds),
                                    child: Text(
                                      bestScore.toString(),
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],

                      // Buttons with enhanced style
                      _GlowingButton(
                        label: 'PLAY',
                        icon: Icons.play_arrow_rounded,
                        onPressed: _startQuickPlay,
                        isPrimary: true,
                      ),
                      const SizedBox(height: 14),
                      _GlowingButton(
                        label: 'SELECT MODE',
                        icon: Icons.grid_view_rounded,
                        onPressed: _openModeSelection,
                        isPrimary: false,
                      ),

                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Floating particles widget
class _FloatingParticles extends StatefulWidget {
  const _FloatingParticles();

  @override
  State<_FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<_FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    final random = math.Random();
    _particles = List.generate(
      25,
      (index) => _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 3 + 1,
        speed: random.nextDouble() * 0.3 + 0.1,
        opacity: random.nextDouble() * 0.4 + 0.1,
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

  _ParticlePainter({required this.particles, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final y = (particle.y + animationValue * particle.speed) % 1.0;
      final paint =
          Paint()
            ..color = AppTheme.primary.withOpacity(particle.opacity)
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

// Glowing button widget
class _GlowingButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _GlowingButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.isPrimary,
  });

  @override
  State<_GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<_GlowingButton> {
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
          gradient:
              widget.isPrimary
                  ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primary, AppTheme.secondary],
                  )
                  : null,
          color: widget.isPrimary ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border:
              widget.isPrimary
                  ? null
                  : Border.all(color: AppTheme.surfaceLight, width: 2),
          boxShadow:
              widget.isPrimary
                  ? [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(
                        _isPressed ? 0.6 : 0.4,
                      ),
                      blurRadius: _isPressed ? 20 : 15,
                      spreadRadius: _isPressed ? 2 : 0,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        transform:
            _isPressed ? (Matrix4.identity()..scale(0.98)) : Matrix4.identity(),
        transformAlignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color:
                  widget.isPrimary
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color:
                    widget.isPrimary
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
