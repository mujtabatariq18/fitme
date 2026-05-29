import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Soft decorative pink blobs behind content — the airy look from the
/// reference screens. Cheap (no blur filter), just translucent circles.
class BlobBackground extends StatelessWidget {
  const BlobBackground({super.key, required this.child, this.tint});

  final Widget child;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // In dark mode a near-white tint reads as grey, so use saturated brand pink.
    final c = tint ?? (isDark ? AppColors.pink : AppColors.pinkTint);
    final a = isDark ? 0.32 : 1.0; // dampen saturated pink on dark surfaces
    return Container(
      color: context.fit.background,
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: _blob(220, c.withValues(alpha: 0.55 * a)),
          ),
          Positioned(
            bottom: -120,
            left: -80,
            child: _blob(260, c.withValues(alpha: 0.45 * a)),
          ),
          Positioned(
            top: 180,
            left: -110,
            child: _blob(180, c.withValues(alpha: 0.30 * a)),
          ),
          child,
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}
