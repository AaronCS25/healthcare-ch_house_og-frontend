import 'package:flutter/material.dart';

enum SnackBarType { success, error, warning, info }

class SnackBarHelper {
  SnackBarHelper._();

  static const Duration _defaultDuration = Duration(seconds: 3);

  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = _defaultDuration,
    String? actionLabel,
    VoidCallback? onActionPressed,
    bool showCloseIcon = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    IconData icon;
    Color iconColor;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = colorScheme.primary;
        icon = Icons.check_circle_outline;
        iconColor = colorScheme.onPrimary;
        break;
      case SnackBarType.error:
        backgroundColor = colorScheme.error;
        icon = Icons.error_outline;
        iconColor = colorScheme.onError;
        break;
      case SnackBarType.warning:
        backgroundColor = Colors.orange;
        icon = Icons.warning_amber_rounded;
        iconColor = Colors.white;
        break;
      case SnackBarType.info:
        backgroundColor = colorScheme.surfaceContainerHighest;
        icon = Icons.info_outline;
        iconColor = colorScheme.onSurface;
        break;
    }

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: type == SnackBarType.info
                    ? colorScheme.onSurface
                    : iconColor,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: showCloseIcon,
      closeIconColor: iconColor,
      action: actionLabel != null && onActionPressed != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: iconColor,
              onPressed: onActionPressed,
            )
          : null,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = _defaultDuration,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.success,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = _defaultDuration,
    String? actionLabel,
    VoidCallback? onActionPressed,
    bool showCloseIcon = true,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.error,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      showCloseIcon: showCloseIcon,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = _defaultDuration,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.warning,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = _defaultDuration,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.info,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
