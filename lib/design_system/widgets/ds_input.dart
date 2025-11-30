import 'package:flutter/material.dart';

class DsInput extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final bool obscureText;
  final String? error;
  final String? helper;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const DsInput({
    super.key,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.leftIcon,
    this.rightIcon,
    this.obscureText = false,
    this.error,
    this.helper,
    this.enabled = true,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          maxLines: obscureText ? 1 : maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: leftIcon,
            suffixIcon: rightIcon,
            filled: true,
            fillColor: cs.surfaceVariant.withOpacity(0.35),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: cs.primary, width: 1.6),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: cs.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: cs.error, width: 1.6),
            ),
            errorText: error,
          ),
        ),
        if (helper != null && (error == null || error!.isEmpty))
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              helper!,
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
