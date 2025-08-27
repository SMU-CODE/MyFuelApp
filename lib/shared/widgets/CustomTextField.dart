import 'package:flutter/material.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isLoginMode;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.isLoginMode,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  void _toggleVisibility() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext _) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: AppSize.mediumFont, color: Colors.black87),
        ),
        SizedBox(height: AppSize.spacingSmall),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscure,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: AppColors.outline),
            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.outline,
                      ),
                      onPressed: _toggleVisibility,
                    )
                    : null,
            hintText: widget.hintText,
            hintStyle: TextStyle(fontSize: AppSize.scaleFont(12)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: AppSize.paddingSmall,
            errorStyle: TextStyle(
              fontSize: AppSize.scaleFont(10),
              color: AppColors.error,
            ),
            errorMaxLines: 3,
            border: _buildBorder(Colors.transparent, 0),
            enabledBorder: _buildBorder(Colors.grey[300]!),
            focusedBorder: _buildBorder(
              widget.isLoginMode ? AppColors.primary : AppColors.secondary,
              1.5,
            ),
            errorBorder: _buildBorder(AppColors.error, 1.5),
            focusedErrorBorder: _buildBorder(AppColors.error, 1.5),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder(Color color, [double width = 1.0]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.radiusMedium),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
