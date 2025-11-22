import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rimac_app/config/config.dart';

class HelpDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onConfirm;

  const HelpDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'Entendido',
    this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Entendido',
    VoidCallback? onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return HelpDialog(
          title: title,
          message: message,
          buttonText: buttonText,
          onConfirm: onConfirm,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 24),

                  child: Icon(
                    Icons.support_agent,
                    size: 64,
                    color: colorScheme.secondary,
                  ),
                ),

                Text(
                  title,
                  textAlign: TextAlign.center,

                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  message,
                  textAlign: TextAlign.center,

                  style: textTheme.bodyLarge?.copyWith(
                    color: AppTheme.gray500,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.darkBgPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      context.pop();
                      onConfirm?.call();
                    },
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 12,
            right: 12,
            child: IconButton(
              icon: const Icon(Icons.close, color: AppTheme.gray500),
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}
