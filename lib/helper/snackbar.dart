import 'package:flutter/material.dart';

enum SnackbarType { success, error, warning, info }

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    required SnackbarType type,
  }) {
    // Configuración según tipo
    IconData icon;
    Color iconColor;
    Color backgroundColor;

    switch (type) {
      case SnackbarType.success:
        icon = Icons.check_circle;
        iconColor = Colors.greenAccent;
        backgroundColor = Colors.green.shade50;
        break;
      case SnackbarType.error:
        icon = Icons.error;
        iconColor = Colors.redAccent;
        backgroundColor = Colors.red.shade50;
        break;
      case SnackbarType.warning:
        icon = Icons.warning_amber_rounded;
        iconColor = Colors.orangeAccent;
        backgroundColor = Colors.orange.shade50;
        break;
      case SnackbarType.info:
      default:
        icon = Icons.info;
        iconColor = Colors.blueAccent;
        backgroundColor = Colors.blue.shade50;
        break;
    }

    // Mostrar snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        showCloseIcon: true,
        duration: const Duration(seconds: 10),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                maxLines: 5,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
