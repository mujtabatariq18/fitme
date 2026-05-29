import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Type system. Headings use Sora (geometric, modern — WHOOP-adjacent),
/// body uses Inter for excellent legibility on dense health data.
class AppType {
  AppType._();

  static TextTheme textTheme(Color primary, Color secondary) {
    final display = GoogleFonts.soraTextTheme();
    final body = GoogleFonts.interTextTheme();

    return TextTheme(
      // Display — onboarding hero titles ("GET RESULTS AT HOME")
      displayLarge: display.displayLarge!.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -0.5,
        color: primary,
      ),
      displayMedium: display.displayMedium!.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.08,
        letterSpacing: -0.4,
        color: primary,
      ),
      headlineMedium: display.headlineMedium!.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.15,
        color: primary,
      ),
      titleLarge: display.titleLarge!.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      titleMedium: body.titleMedium!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: body.bodyLarge!.copyWith(
        fontSize: 16,
        height: 1.45,
        color: primary,
      ),
      bodyMedium: body.bodyMedium!.copyWith(
        fontSize: 14,
        height: 1.45,
        color: secondary,
      ),
      labelLarge: body.labelLarge!.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: primary,
      ),
      labelMedium: body.labelMedium!.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        color: secondary,
      ),
    );
  }

  /// Big numeric readout for metric cards (calories, weight, kcal).
  static TextStyle metric(Color color) => GoogleFonts.sora(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        color: color,
      );
}
