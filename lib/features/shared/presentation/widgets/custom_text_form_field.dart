import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? errorMessage;
  final bool isEnabled;
  final bool obscureText;
  final bool induceError;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    this.label,
    this.hintText,
    this.onChanged,
    this.focusNode,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.errorMessage,
    this.onFieldSubmitted,
    this.onTap,
    this.isEnabled = true,
    this.obscureText = false,
    this.induceError = false,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.minLines,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inputTheme = theme.inputDecorationTheme;

    final baseBorder =
        inputTheme.border as OutlineInputBorder? ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: colorScheme.outline),
        );

    final enabledBorder =
        inputTheme.enabledBorder as OutlineInputBorder? ??
        baseBorder.copyWith(borderSide: BorderSide(color: colorScheme.outline));

    final focusedBorder =
        inputTheme.focusedBorder as OutlineInputBorder? ??
        baseBorder.copyWith(
          borderSide: BorderSide(color: colorScheme.primary, width: 1),
        );

    final errorBorder = baseBorder.copyWith(
      borderSide: BorderSide(color: colorScheme.error),
    );

    OutlineInputBorder currentBorder = enabledBorder;
    OutlineInputBorder currentFocusedBorder = focusedBorder;

    if (induceError || errorMessage != null) {
      currentBorder = errorBorder;
      currentFocusedBorder = errorBorder;
    }

    final enabledColor = colorScheme.onSurface;
    final disabledColor = colorScheme.onSurface.withValues(alpha: 0.38);

    return TextFormField(
      style: theme.textTheme.bodyLarge?.copyWith(
        color: isEnabled ? enabledColor : disabledColor,
      ),
      enabled: isEnabled,
      readOnly: readOnly,
      onChanged: onChanged,
      focusNode: focusNode,
      controller: controller,
      obscureText: obscureText,
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
      cursorColor: colorScheme.primary,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      decoration: InputDecoration(
        filled: true,
        fillColor: isEnabled
            ? (inputTheme.fillColor ?? colorScheme.surface)
            : colorScheme.surface.withValues(alpha: 0.5),
        enabledBorder: currentBorder,
        disabledBorder: currentBorder.copyWith(
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: currentFocusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        labelText: label,
        hintText: hintText,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: isEnabled
              ? colorScheme.onSurfaceVariant
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        hintStyle:
            inputTheme.hintStyle ??
            theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        errorText: errorMessage,
        errorStyle: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.error,
        ),
        prefixIcon: prefixIcon != null
            ? IconTheme(
                data: IconThemeData(
                  color: isEnabled
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                child: prefixIcon!,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? IconTheme(
                data: IconThemeData(
                  color: isEnabled
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                child: suffixIcon!,
              )
            : null,
        contentPadding:
            inputTheme.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
