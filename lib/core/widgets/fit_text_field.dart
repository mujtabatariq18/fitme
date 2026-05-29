import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

/// Themed text input used across auth and forms.
class FitTextField extends StatelessWidget {
  const FitTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.icon,
    this.obscure = false,
    this.keyboardType,
    this.onChanged,
    this.suffix,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final IconData? icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon == null ? null : Icon(icon, color: fit.textTertiary),
        suffixIcon: suffix,
        filled: true,
        fillColor: fit.surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: BorderSide(color: fit.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: BorderSide(color: fit.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: const BorderSide(color: AppColors.pink, width: 2),
        ),
      ),
    );
  }
}
