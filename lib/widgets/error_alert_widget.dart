// error_alert_widget.dart
import 'package:flutter/material.dart';

class ErrorAlertWidget {
  /// Muestra errores de validación en un SnackBar
  static void showValidationErrors({
    required BuildContext context,
    required Map<String, dynamic> response,
    String title = 'Error de validación',
    Duration duration = const Duration(seconds: 5),
  }) {
    if (response['success'] == false && response.containsKey('errors')) {
      final errors = response['errors'] as Map<String, dynamic>;

      final errorMessages = _parseErrors(errors);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              ...errorMessages.map((error) => Text(
                    '• $error',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  )),
            ],
          ),
          backgroundColor: Colors.red[800],
          duration: duration,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  /// Muestra un error genérico
  static void showGenericError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: duration,
      ),
    );
  }

  /// Muestra un mensaje de éxito
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: duration,
      ),
    );
  }

  /// Parsea los errores del response a una lista de mensajes
  static List<String> _parseErrors(Map<String, dynamic> errors) {
    final List<String> errorList = [];

    errors.forEach((field, messages) {
      if (messages is List) {
        for (var message in messages) {
          errorList.add('${_translateField(field)}: $message');
        }
      } else if (messages is String) {
        errorList.add('${_translateField(field)}: $messages');
      }
    });

    return errorList;
  }

  /// Traduce los nombres de campos al español
  static String _translateField(String field) {
    final translations = {
      'email': 'Correo electrónico',
      'idPastor': 'Pastor',
      'nombre': 'Nombre',
      'password': 'Contraseña',
      'telefono': 'Teléfono',
      'direccion': 'Dirección',
      'ciudad': 'Ciudad',
      'pais': 'País',
      'fecha_nacimiento': 'Fecha de nacimiento',
      'descripcion': 'Descripción',
      'titulo': 'Título',
      'contenido': 'Contenido',
      'precio': 'Precio',
      'cantidad': 'Cantidad',
      'categoria': 'Categoría',
    };

    return translations[field] ?? field;
  }
}
