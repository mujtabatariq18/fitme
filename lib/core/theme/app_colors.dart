import 'package:flutter/material.dart';

/// FitMe brand palette.
///
/// Brand colors are constant across light/dark themes — they are the identity.
/// Surface / text colors that adapt to brightness live in [FitColors]
/// (a [ThemeExtension]) so widgets read semantic tokens from `context`.
class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color pink = Color(0xFFFF2E93); // primary hot pink
  static const Color pinkBright = Color(0xFFFF4DA6);
  static const Color magenta = Color(0xFFC01C92); // card headers
  static const Color deepMagenta = Color(0xFF8E1378);
  static const Color pinkTint = Color(0xFFFFE3F2); // soft fill / blobs
  static const Color pinkTintStrong = Color(0xFFFFC9E6);

  // ── Progress / data accent (the blue tracking screen) ──────────────────────
  static const Color blue = Color(0xFF1696F2);
  static const Color blueDark = Color(0xFF0A7BE0);
  static const Color blueTint = Color(0xFFCDEBFF);

  // ── Status ─────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF21C17A);
  static const Color warning = Color(0xFFFFB020);
  static const Color danger = Color(0xFFEF4F56);

  // ── WHOOP-style metric ring colors ──────────────────────────────────────────
  static const Color strain = Color(0xFF1696F2);
  static const Color recovery = Color(0xFF21C17A);
  static const Color sleep = Color(0xFF7C5CFF);
  static const Color calories = Color(0xFFFF7A45);

  // ── Neutrals (raw scale, theme-agnostic) ─────────────────────────────────────
  static const Color ink900 = Color(0xFF1A1A24);
  static const Color ink700 = Color(0xFF3A3A45);
  static const Color ink500 = Color(0xFF6B6B78);
  static const Color ink300 = Color(0xFFADADB8);
  static const Color ink100 = Color(0xFFECECF2);

  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF7F8FA);
  static const Color pinkBg = Color(0xFFFFF5FA); // app background wash (light)

  // Dark surfaces
  static const Color night0 = Color(0xFF0E0E14);
  static const Color night1 = Color(0xFF16161F);
  static const Color night2 = Color(0xFF1E1E2A);
  static const Color night3 = Color(0xFF2A2A38);
}

/// Semantic, brightness-aware tokens. Read via `context.fit` (see extension).
@immutable
class FitColors extends ThemeExtension<FitColors> {
  const FitColors({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.surfaceInverse,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textOnBrand,
    required this.shadow,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color surfaceInverse;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textOnBrand;
  final Color shadow;

  static const light = FitColors(
    background: AppColors.pinkBg,
    surface: AppColors.white,
    surfaceAlt: AppColors.offWhite,
    surfaceInverse: AppColors.ink900,
    border: AppColors.ink100,
    textPrimary: AppColors.ink900,
    textSecondary: AppColors.ink500,
    textTertiary: AppColors.ink300,
    textOnBrand: AppColors.white,
    shadow: Color(0x14101828),
  );

  static const dark = FitColors(
    background: AppColors.night0,
    surface: AppColors.night1,
    surfaceAlt: AppColors.night2,
    surfaceInverse: AppColors.white,
    border: AppColors.night3,
    textPrimary: Color(0xFFF3F3F7),
    textSecondary: Color(0xFFA0A0B0),
    textTertiary: Color(0xFF6A6A7A),
    textOnBrand: AppColors.white,
    shadow: Color(0x40000000),
  );

  @override
  FitColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? surfaceInverse,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textOnBrand,
    Color? shadow,
  }) {
    return FitColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      surfaceInverse: surfaceInverse ?? this.surfaceInverse,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textOnBrand: textOnBrand ?? this.textOnBrand,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  FitColors lerp(ThemeExtension<FitColors>? other, double t) {
    if (other is! FitColors) return this;
    return FitColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      surfaceInverse: Color.lerp(surfaceInverse, other.surfaceInverse, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textOnBrand: Color.lerp(textOnBrand, other.textOnBrand, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}
