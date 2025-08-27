import 'package:flutter/material.dart';
import 'package:my_fuel/features/Auth/Controllers/AuthController.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final AuthMode authMode;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final bool autoFocus;
  final int? maxLength;
  final int? minLength;

  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.authMode,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autoFocus = false,
    this.maxLength,
    this.minLength,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() => _obscureText = !_obscureText);
  }


  Color _getActiveColor(AuthMode mode) {
    switch (mode) {
      case AuthMode.login:
        return AppColors.primary;
      case AuthMode.signUp:
        return AppColors.secondary;
      case AuthMode.changePassword:
        return Colors.purple;
      case AuthMode.restPassword:
        return Colors.indigo;
      case AuthMode.logout:
        return Colors.red;
      case AuthMode.otp:
        return const Color.fromARGB(255, 244, 244, 54);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (_) => setState(() {}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontSize: AppSize.mediumFont,
              color: AppColors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppSize.spacingSmall),
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: _obscureText,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction ?? TextInputAction.next,
            onFieldSubmitted: widget.onFieldSubmitted,
            autofocus: widget.autoFocus,
            maxLength: widget.maxLength,
            decoration: InputDecoration(
              prefixIcon: Icon(
                widget.icon,
                color:
                    _focusNode.hasFocus
                        ? _getActiveColor(widget.authMode)
                        : AppColors.outline,
              ),
              suffixIcon:
                  widget.isPassword
                      ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color:
                              _focusNode.hasFocus
                                  ? _getActiveColor(widget.authMode)
                                  : AppColors.outline,
                        ),
                        onPressed: _toggleVisibility,
                      )
                      : null,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: AppSize.scaleFont(14),
                color: AppColors.onSurface.withValues(alpha: 0.6),
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: AppSize.paddingSmall,
              errorStyle: TextStyle(
                fontSize: AppSize.scaleFont(10),
                color: AppColors.error,
              ),
              errorMaxLines: 3,
              counterText: '',
              border: _buildBorder(Colors.transparent),
              enabledBorder: _buildBorder(AppColors.outline),
              focusedBorder: _buildBorder(
                _getActiveColor(widget.authMode),
                1.5,
              ),
              errorBorder: _buildBorder(AppColors.error, 1.5),
              focusedErrorBorder: _buildBorder(AppColors.error, 1.5),
            ),
            style: TextStyle(color: AppColors.onSurface),
          ),
          if (widget.minLength != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'الحد الأدنى: ${widget.minLength} أحرف',
                style: TextStyle(
                  fontSize: AppSize.scaleFont(10),
                  color: AppColors.outline,
                ),
              ),
            ),
        ],
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color, [double width = 1.0]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.radiusMedium),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
