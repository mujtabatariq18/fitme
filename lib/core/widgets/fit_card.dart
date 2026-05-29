import 'package:flutter/material.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

/// Soft floating surface used everywhere (meal cards, stat cards, etc.).
class FitCard extends StatelessWidget {
  const FitCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Insets.lg),
    this.onTap,
    this.color,
    this.radius = Radii.md,
    this.clip = false,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? color;
  final double radius;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    final card = Container(
      decoration: BoxDecoration(
        color: color ?? fit.surface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: Shadows.card(fit.shadow),
      ),
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: card,
      ),
    );
  }
}
