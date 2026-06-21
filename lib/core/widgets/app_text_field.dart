import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Labeled text field matching `AuthField` in the design handoff: bold label
/// above a 52pt white box with a leading icon, optional password visibility
/// toggle, and inline error.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.icon,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.errorText,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final IconData? icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscure;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: 1.5),
      );

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
        const SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          obscureText: _obscured,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: AppColors.paper,
            hintText: widget.hint,
            hintStyle: const TextStyle(color: AppColors.placeholder, fontWeight: FontWeight.w400),
            errorText: widget.errorText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
            prefixIcon: widget.icon == null ? null : Icon(widget.icon, size: 18, color: AppColors.muted),
            prefixIconConstraints: const BoxConstraints(minWidth: 42),
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(_obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: AppColors.eyeIcon),
                    onPressed: () => setState(() => _obscured = !_obscured),
                  )
                : null,
            enabledBorder: _border(hasError ? AppColors.red : AppColors.fieldBorder),
            focusedBorder: _border(hasError ? AppColors.red : AppColors.chipBlue),
            errorBorder: _border(AppColors.red),
            focusedErrorBorder: _border(AppColors.red),
          ),
        ),
      ],
    );
  }
}
