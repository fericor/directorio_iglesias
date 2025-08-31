import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/pages/main.page.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class DeleteAccountButton extends StatelessWidget {
  final String userId; // El ID del usuario actual
  final String apiUrl; // Ej: "https://tuapi.com/api/users"

  const DeleteAccountButton({
    super.key,
    required this.userId,
    required this.apiUrl,
  });

  Future<void> _deleteAccount(BuildContext context) async {
    await initLocalStorage();

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // ✅ Cuenta eliminada correctamente
        if (context.mounted) {
          AppSnackbar.show(
            context,
            message: 'Cuenta eliminada correctamente.',
            type: SnackbarType.success,
          );

          localStorage.removeItem('isLogin');
          localStorage.removeItem('miIdUser');
          localStorage.removeItem('miToken');
          localStorage.removeItem('miIglesia');

          // Aquí podrías cerrar sesión y redirigir al login
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPageView()),
          );
        }
      } else {
        // ❌ Error en el servidor
        if (context.mounted) {
          AppSnackbar.show(
            context,
            message: "Error al eliminar cuenta: ${response.body}",
            type: SnackbarType.error,
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
    return GestureDetector(
      onTap: () => _confirmDelete(context),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsUtils.rojoColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.delete_forever, color: ColorsUtils.blancoColor),
              const SizedBox(width: 8),
              Text(
                "Eliminar cuenta",
                style: TextStyle(
                  color: ColorsUtils.blancoColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
