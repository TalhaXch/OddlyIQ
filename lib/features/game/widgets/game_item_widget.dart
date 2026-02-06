import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/game_item.dart';
import '../../../core/constants/app_constants.dart';

class GameItemWidget extends StatefulWidget {
  final GameItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const GameItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<GameItemWidget> createState() => _GameItemWidgetState();
}

class _GameItemWidgetState extends State<GameItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(GameItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _backgroundColor {
    if (!widget.isSelected) {
      return AppTheme.surfaceColor;
    }
    return widget.item.isOdd ? AppTheme.correctColor : AppTheme.wrongColor;
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: widget.isSelected ? null : widget.onTap,
        child: AnimatedContainer(
          duration: AppConstants.animationDuration,
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            boxShadow: [AppTheme.softShadow],
          ),
          child: Center(
            child: Transform.rotate(
              angle: widget.item.rotation * math.pi / 180,
              child: Transform.scale(
                scale: widget.item.scale,
                child: Opacity(
                  opacity: widget.item.opacity,
                  child: _buildContent(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (widget.item.type) {
      case ItemType.shape:
        return _buildShape();
      case ItemType.color:
        return _buildColorBox();
      case ItemType.icon:
        return _buildIcon();
      case ItemType.number:
        return _buildNumber();
      case ItemType.symbol:
        return _buildSymbol();
    }
  }

  Widget _buildShape() {
    final color = widget.item.color ?? AppTheme.primaryColor;

    return CustomPaint(
      size: const Size(60, 60),
      painter: ShapePainter(
        shapeType: widget.item.shape ?? ShapeType.circle,
        color: color,
      ),
    );
  }

  Widget _buildColorBox() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: widget.item.color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildIcon() {
    return Icon(widget.item.icon, size: 48, color: widget.item.color);
  }

  Widget _buildNumber() {
    return Text(
      widget.item.number ?? '',
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: widget.item.color,
      ),
    );
  }

  Widget _buildSymbol() {
    return Text(
      widget.item.symbol ?? '',
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: widget.item.color,
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final ShapeType shapeType;
  final Color color;

  ShapePainter({required this.shapeType, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    switch (shapeType) {
      case ShapeType.circle:
        canvas.drawCircle(center, radius, paint);
        break;
      case ShapeType.square:
        canvas.drawRect(
          Rect.fromCenter(
            center: center,
            width: size.width,
            height: size.height,
          ),
          paint,
        );
        break;
      case ShapeType.triangle:
        final path =
            Path()
              ..moveTo(center.dx, 0)
              ..lineTo(size.width, size.height)
              ..lineTo(0, size.height)
              ..close();
        canvas.drawPath(path, paint);
        break;
      case ShapeType.star:
        _drawStar(canvas, center, radius, paint);
        break;
      case ShapeType.diamond:
        final path =
            Path()
              ..moveTo(center.dx, 0)
              ..lineTo(size.width, center.dy)
              ..lineTo(center.dx, size.height)
              ..lineTo(0, center.dy)
              ..close();
        canvas.drawPath(path, paint);
        break;
      case ShapeType.hexagon:
        _drawHexagon(canvas, center, radius, paint);
        break;
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    const points = 5;
    final angle = math.pi / points;
    final path = Path();

    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : radius / 2;
      final currentAngle = i * angle - math.pi / 2;
      final x = center.dx + r * math.cos(currentAngle);
      final y = center.dy + r * math.sin(currentAngle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
