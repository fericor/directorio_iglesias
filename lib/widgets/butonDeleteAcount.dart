import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteAccountButton extends StatelessWidget {
  final String userId; // El ID del usuario actual
  final String apiUrl; // Ej: "https://tuapi.com/api/users"

  const DeleteAccountButton({
    super.key,
    required this.userId,
    required this.apiUrl,
  });

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$userId'));

      if (response.statusCode == 200) {
        // ✅ Cuenta eliminada correctamente
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Cuenta eliminada correctamente.")),
          );
          // Aquí podrías cerrar sesión y redirigir al login
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        // ❌ Error en el servidor
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Error al eliminar cuenta: ${response.body}")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error de conexión: $e")),
        );
      }
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Eliminar cuenta"),
          content: const Text(
              "¿Seguro que deseas eliminar tu cuenta? Esta acción no se puede deshacer."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                _deleteAccount(context);
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      icon: const Icon(Icons.delete_forever),
      label: const Text("Eliminar cuenta"),
      onPressed: () => _confirmDelete(context),
    );
  }
}
