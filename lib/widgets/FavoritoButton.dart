import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoritoButton extends StatefulWidget {
  final String idUsuario;
  final String idIglesia;
  final String token;
  final bool inicial; // estado inicial desde la API

  const FavoritoButton(
      {required this.idUsuario,
      required this.idIglesia,
      required this.token,
      required this.inicial,
      super.key});

  @override
  State<FavoritoButton> createState() => _FavoritoButtonState();
}

class _FavoritoButtonState extends State<FavoritoButton> {
  bool isFavorito = false;

  Future<void> toggleFavorito() async {
    final url = Uri.parse(
        "${MainUtils.urlHostApi}/iglesiaFavoritos?api_token=${widget.token}");

    try {
      if (isFavorito) {
        // quitar favorito
        await http.delete(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "idUsuario": widget.idUsuario,
            "idIglesia": widget.idIglesia,
          }),
        );

        AppSnackbar.show(
          context,
          message: "Iglesia eliminada de favoritos ✅",
          type: SnackbarType.error,
        );
      } else {
        // añadir favorito
        await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "idUsuario": widget.idUsuario,
            "idIglesia": widget.idIglesia,
          }),
        );

        AppSnackbar.show(
          context,
          message: "Iglesia añadida a favoritos ✅",
          type: SnackbarType.success,
        );
      }

      setState(() {
        isFavorito = !isFavorito;
      });
    } catch (e) {
      print("Error al cambiar favorito: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorito ? Icons.favorite : Icons.favorite_border,
        color: isFavorito ? Colors.red : Colors.grey,
      ),
      onPressed: toggleFavorito,
    );
  }
}
