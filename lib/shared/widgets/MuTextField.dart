import 'package:flutter/material.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

/// 🎨 MuTextField - حقل إدخال عصري بجماليات مدمجة.
class MuTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final TextStyle? labelStyle;
  final TextStyle? hentStyle;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final IconData? icon;

  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int? maxLines;

  const MuTextField({
    super.key,
    required this.controller,
    this.label = '',
    this.hintText,
    this.labelStyle,
    this.hentStyle,

    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.icon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: theme.colorScheme.primary..withValues(alpha: 0.5),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.spacingMedium),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        enabled: enabled,
        maxLines: obscureText ? 1 : maxLines,
        style: theme.textTheme.titleMedium?.copyWith(
          color: enabled ? theme.colorScheme.onSurface : Colors.grey,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: theme.colorScheme.surface..withValues(alpha: 0.05),
          labelText: label,
          hintText: hintText,
          prefixIcon: prefixIcon ?? Icon(icon),
          suffixIcon: suffixIcon,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle:
              labelStyle ??
              TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: theme.colorScheme.primary.withValues(alpha: .8),
              ),
          hintStyle:
              hentStyle ??
              TextStyle(color: theme.hintColor, fontStyle: FontStyle.italic),
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
          errorBorder: border.copyWith(
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: border.copyWith(
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          disabledBorder: border.copyWith(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}
