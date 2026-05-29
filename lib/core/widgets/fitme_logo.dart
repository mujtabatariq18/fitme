import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_shadows.dart';
import '../theme/app_theme.dart';

/// The FitMe icon mark: a gradient rounded-square containing a stylized
/// heartbeat-pulse "F". Drawn as vector so it stays crisp at any size and
/// renders identically on every platform.
class FitMeMark extends StatelessWidget {
  const FitMeMark({super.key, this.size = 64, this.glow = true});

  final double size;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppGradients.brand,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: glow ? Shadows.glow(AppColors.pink) : null,
      ),
      child: CustomPaint(painter: _PulseFPainter()),
    );
  }
}

class _PulseFPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = w * 0.11;
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Vertical stem of the "F".
    canvas.drawLine(
      Offset(w * 0.32, h * 0.24),
      Offset(w * 0.32, h * 0.76),
      paint,
    );

    // Top arm of the "F" rendered as a heartbeat pulse.
    final pulse = Path()
      ..moveTo(w * 0.32, h * 0.30)
      ..lineTo(w * 0.50, h * 0.30)
      ..lineTo(w * 0.58, h * 0.16)
      ..lineTo(w * 0.66, h * 0.44)
      ..lineTo(w * 0.74, h * 0.30)
      ..lineTo(w * 0.82, h * 0.30);
    canvas.drawPath(pulse, paint);

    // Middle arm.
    canvas.drawLine(
      Offset(w * 0.32, h * 0.52),
      Offset(w * 0.60, h * 0.52),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// The AI-generated brand icon (PNG) with rounded corners + glow.
/// Use for hero placements; [FitMeMark] is the vector fallback for tiny sizes.
class FitMeBrandImage extends StatelessWidget {
  const FitMeBrandImage({super.key, this.size = 96, this.glow = true});

  final double size;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: glow ? Shadows.glow(AppColors.pink) : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.28),
        child: Image.asset(
          'assets/brand/logo_a.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          // Fall back to the vector mark if the asset is ever missing.
          errorBuilder: (_, _, _) => FitMeMark(size: size, glow: false),
        ),
      ),
    );
  }
}

/// Full lockup: mark + "Fit" / "Me" wordmark.
class FitMeLogo extends StatelessWidget {
  const FitMeLogo({super.key, this.markSize = 40, this.fontSize = 28});

  final double markSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FitMeMark(size: markSize, glow: false),
        SizedBox(width: markSize * 0.32),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: fontSize,
                  letterSpacing: -0.5,
                ),
            children: [
              TextSpan(
                text: 'Fit',
                style: TextStyle(color: fit.textPrimary),
              ),
              const TextSpan(
                text: 'Me',
                style: TextStyle(color: AppColors.pink),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
