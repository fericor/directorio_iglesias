import 'dart:convert';
import 'dart:io';

import 'package:conexion_mas/models/MisIglesiaImagen.dart';
import 'package:http/http.dart' as http;

class MisIglesiaImagenService {
  final String _baseUrl;
  final http.Client _httpClient;

  MisIglesiaImagenService({required String baseUrl, http.Client? httpClient})
      : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client();

  // Obtener imágenes de una iglesia
  Future<List<IglesiaImagen>> getImagenesByIglesia(
      String idIglesia, String token) async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/iglesias/$idIglesia/imagenes?api_token=$token'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => IglesiaImagen.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener imágenes: ${response.statusCode}');
    }
  }

  // Subir imagen a la galería
  Future<IglesiaImagen> subirImagen(
      String idIglesia, File imagen, String token) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          '$_baseUrl/iglesias/$idIglesia/imagenesGaleria?api_token=$token'),
    );

    request.files
        .add(await http.MultipartFile.fromPath('imagenes', imagen.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(responseBody);

      if (data['success'] == true) {
        return IglesiaImagen.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Error al subir imagen');
      }
    } else {
      throw Exception('Error al subir imagen: ${response.statusCode}');
    }
  }

  // Eliminar imagen
  Future<void> eliminarImagen(String idImagen, String token) async {
    final response = await _httpClient.delete(
      Uri.parse('$_baseUrl/iglesias/imagenes/$idImagen?api_token=$token'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Error al eliminar imagen');
      }
    } else {
      throw Exception('Error al eliminar imagen: ${response.statusCode}');
    }
  }

  // Actualizar imagen (activar/desactivar)
  Future<List<IglesiaImagen>> actualizarImagen(
      IglesiaImagen imagen, String token) async {
    final response = await _httpClient.put(
      Uri.parse(
          '$_baseUrl/iglesias/imagenes/${imagen.idImagen}?api_token=$token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(imagen.toJson()),
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((jsonEventos) => IglesiaImagen.fromJson(jsonEventos))
          .toList();
    } else {
      throw Exception('Error al actualizar imagen: ${response.statusCode}');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
