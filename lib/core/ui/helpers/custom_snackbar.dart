import 'package:bikers_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum MessageType { success, error, info }

class CustomSnackBar {
  /// Muestra un snackbar personalizado
  static void show(
    BuildContext context, {
    required String message,
    MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 2),
    bool top = false,
    IconData? icon,
  }) {
    final theme = Theme.of(context).colorScheme;
    final color = _getColor(type, theme);
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
          ],
          Expanded(child: Text(message)),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      margin: top
          ? EdgeInsets.only(top: 16, left: 16, right: 16)
          : EdgeInsets.only(bottom: 16, left: 16, right: 16),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Color _getColor(MessageType type, ColorScheme theme) {
    switch (type) {
      case MessageType.success:
        return AppColors.successGreen;
      case MessageType.error:
        return AppColors.errorRed;
      case AppColors.infoBlue:
      default:
        return AppColors.warningAmber;
    }
  }
}
