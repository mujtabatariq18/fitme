import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Animated stylized human figure avatar that oscillates arms/legs to suggest
/// exercising. Pure vector via [CustomPainter] — no external assets required.
class ExerciseAvatar extends StatefulWidget {
  const ExerciseAvatar({
    super.key,
    required this.isMale,
    this.size = 220,
    this.animating = true,
  });

  final bool isMale;
  final double size;
  final bool animating;

  @override
  State<ExerciseAvatar> createState() => _ExerciseAvatarState();
}

class _ExerciseAvatarState extends State<ExerciseAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.animating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ExerciseAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.animating && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
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
      builder: (context, _) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _AvatarPainter(
            t: _controller.value,
            isMale: widget.isMale,
          ),
        );
      },
    );
  }
}

class _AvatarPainter extends CustomPainter {
  _AvatarPainter({required this.t, required this.isMale});

  final double t;
  final bool isMale;

  // t oscillates 0 → 1 → 0 (reverse: true), so swing = sin(t * pi)
  double get _swing => math.sin(t * math.pi);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final scale = size.width / 220;

    // Gender-specific tweaks
    final Color skinColor =
        isMale ? const Color(0xFFFFCBA4) : const Color(0xFFFFB8A0);
    final Color shirtColor =
        isMale ? AppColors.blue : AppColors.pink;
    final Color shortColor =
        isMale ? AppColors.ink700 : AppColors.magenta;
    final double shoulderWidth = isMale ? 52 : 44;
    final double hipWidth = isMale ? 38 : 44;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    // ── Head ────────────────────────────────────────────────────────────────
    final headRadius = 22 * scale;
    final headCenter = Offset(cx, 30 * scale);
    fillPaint.color = skinColor;
    canvas.drawCircle(headCenter, headRadius, fillPaint);
    paint
      ..color = skinColor.withValues(alpha: 0.6)
      ..strokeWidth = 1.5 * scale;
    canvas.drawCircle(headCenter, headRadius, paint);

    // Hair
    final hairPaint = Paint()
      ..color = isMale ? AppColors.ink700 : const Color(0xFF5C2D00)
      ..style = PaintingStyle.fill;
    final hairPath = Path();
    hairPath.addArc(
      Rect.fromCircle(center: headCenter, radius: headRadius),
      math.pi,
      math.pi,
    );
    hairPath.close();
    canvas.drawPath(hairPath, hairPaint);

    // Eyes
    final eyePaint = Paint()
      ..color = AppColors.ink900
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(cx - 7 * scale, 28 * scale), 2.5 * scale, eyePaint);
    canvas.drawCircle(
        Offset(cx + 7 * scale, 28 * scale), 2.5 * scale, eyePaint);

    // Smile
    paint
      ..color = AppColors.ink700
      ..strokeWidth = 1.8 * scale;
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(cx, 35 * scale), width: 14 * scale, height: 8 * scale),
      0,
      math.pi,
      false,
      paint,
    );

    // ── Neck ────────────────────────────────────────────────────────────────
    fillPaint.color = skinColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx, 57 * scale), width: 12 * scale, height: 10 * scale),
        const Radius.circular(4),
      ),
      fillPaint,
    );

    // ── Torso (shirt) ────────────────────────────────────────────────────────
    final torsoTop = 62 * scale;
    final torsoBottom = 115 * scale;
    final torsoPath = Path();
    torsoPath.moveTo(cx - shoulderWidth / 2 * scale, torsoTop);
    torsoPath.lineTo(cx + shoulderWidth / 2 * scale, torsoTop);
    torsoPath.lineTo(cx + hipWidth / 2 * scale, torsoBottom);
    torsoPath.lineTo(cx - hipWidth / 2 * scale, torsoBottom);
    torsoPath.close();
    fillPaint.color = shirtColor;
    canvas.drawPath(torsoPath, fillPaint);

    // Torso outline
    paint
      ..color = shirtColor.withValues(alpha: 0.7)
      ..strokeWidth = 1.5 * scale;
    canvas.drawPath(torsoPath, paint);

    // ── Shorts / hips ────────────────────────────────────────────────────────
    final shortsPath = Path();
    shortsPath.moveTo(cx - hipWidth / 2 * scale, torsoBottom);
    shortsPath.lineTo(cx + hipWidth / 2 * scale, torsoBottom);
    shortsPath.lineTo(cx + hipWidth / 2 * scale, (torsoBottom + 18 * scale));
    shortsPath.lineTo(cx, (torsoBottom + 20 * scale));
    shortsPath.lineTo(cx - hipWidth / 2 * scale, (torsoBottom + 18 * scale));
    shortsPath.close();
    fillPaint.color = shortColor;
    canvas.drawPath(shortsPath, fillPaint);

    // ── Arms ────────────────────────────────────────────────────────────────
    // Arms oscillate opposite to each other: left arm fwd = right arm back
    final armSwing = _swing * 28; // degrees in px offset
    final armStroke = 9 * scale;
    paint
      ..color = shirtColor
      ..strokeWidth = armStroke;

    final shoulderY = 70 * scale;

    // Left arm (swings forward/up when t>0.5, back when t<0.5)
    final leftElbow = Offset(
      cx - shoulderWidth / 2 * scale - 12 * scale,
      (shoulderY + 20 * scale) - armSwing * scale * 0.3,
    );
    final leftHand = Offset(
      cx - shoulderWidth / 2 * scale - 20 * scale + armSwing * scale * 0.2,
      (shoulderY + 45 * scale) - armSwing * scale * 0.4,
    );
    _drawArmSegment(
        canvas,
        paint,
        Offset(cx - shoulderWidth / 2 * scale, shoulderY),
        leftElbow,
        leftHand,
        skinColor,
        scale);

    // Right arm (opposite phase)
    final rightElbow = Offset(
      cx + shoulderWidth / 2 * scale + 12 * scale,
      (shoulderY + 20 * scale) + armSwing * scale * 0.3,
    );
    final rightHand = Offset(
      cx + shoulderWidth / 2 * scale + 20 * scale - armSwing * scale * 0.2,
      (shoulderY + 45 * scale) + armSwing * scale * 0.4,
    );
    _drawArmSegment(
        canvas,
        paint,
        Offset(cx + shoulderWidth / 2 * scale, shoulderY),
        rightElbow,
        rightHand,
        skinColor,
        scale);

    // ── Legs ────────────────────────────────────────────────────────────────
    final legStroke = 11 * scale;
    final hipY = torsoBottom + 18 * scale;
    final legSwing = _swing * 20;

    // Left leg
    final leftKnee = Offset(
      cx - 14 * scale,
      (hipY + 30 * scale) + legSwing * scale * 0.3,
    );
    final leftFoot = Offset(
      cx - 18 * scale + legSwing * scale * 0.2,
      (hipY + 58 * scale) + legSwing * scale * 0.1,
    );
    paint
      ..color = shortColor
      ..strokeWidth = legStroke;
    canvas.drawLine(Offset(cx - 10 * scale, hipY), leftKnee, paint);
    paint.color = skinColor;
    canvas.drawLine(leftKnee, leftFoot, paint);
    // Shoe
    _drawShoe(canvas, leftFoot, scale, isMale);

    // Right leg (opposite)
    final rightKnee = Offset(
      cx + 14 * scale,
      (hipY + 30 * scale) - legSwing * scale * 0.3,
    );
    final rightFoot = Offset(
      cx + 18 * scale - legSwing * scale * 0.2,
      (hipY + 58 * scale) - legSwing * scale * 0.1,
    );
    paint
      ..color = shortColor
      ..strokeWidth = legStroke;
    canvas.drawLine(Offset(cx + 10 * scale, hipY), rightKnee, paint);
    paint.color = skinColor;
    canvas.drawLine(rightKnee, rightFoot, paint);
    _drawShoe(canvas, rightFoot, scale, isMale);

    // ── Brand glow ring ──────────────────────────────────────────────────────
    final glowPaint = Paint()
      ..color = AppColors.pink.withValues(alpha: 0.12 + _swing * 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * scale;
    canvas.drawCircle(
        Offset(cx, size.height / 2 + 10 * scale),
        size.width * 0.42,
        glowPaint);
  }

  void _drawArmSegment(
      Canvas canvas,
      Paint paint,
      Offset shoulder,
      Offset elbow,
      Offset hand,
      Color skinColor,
      double scale) {
    // Upper arm (shirt colored — paint already set by caller)
    canvas.drawLine(shoulder, elbow, paint);
    // Forearm skin
    final forearmPaint = Paint()
      ..color = skinColor
      ..strokeWidth = paint.strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(elbow, hand, forearmPaint);
  }

  void _drawShoe(Canvas canvas, Offset foot, double scale, bool isMale) {
    final shoePaint = Paint()
      ..color = isMale ? AppColors.ink900 : AppColors.deepMagenta
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(foot.dx + 4 * scale, foot.dy + 3 * scale),
            width: 16 * scale,
            height: 8 * scale),
        Radius.circular(4 * scale),
      ),
      shoePaint,
    );
  }

  @override
  bool shouldRepaint(_AvatarPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.isMale != isMale;
}
