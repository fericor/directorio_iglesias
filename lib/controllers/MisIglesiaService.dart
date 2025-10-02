import 'dart:convert';
import 'dart:io';
import 'package:conexion_mas/models/MisIglesias.dart';
import 'package:conexion_mas/models/iglesias.dart';
import 'package:http/http.dart' as http;

class MisIglesiaService {
  final String _baseUrl;
  final http.Client _httpClient;

  MisIglesiaService({required String baseUrl, http.Client? httpClient})
      : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client();

  // Obtener todas las iglesias
  Future<List<Iglesias>> getIglesias(String token) async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/iglesias?api_token=$token'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Iglesias.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener iglesias: ${response.statusCode}');
    }
  }

  // Obtener todas las iglesias
  Future<List<Iglesias>> getIglesiasUser(String token, idUser) async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/iglesiasUser/$idUser?api_token=$token'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Iglesias.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener iglesias: ${response.statusCode}');
    }
  }

  // Obtener una iglesia por ID
  Future<MisIglesia> getIglesiaById(String id, String token) async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/iglesias/$id?api_token=$token'),
    );

    if (response.statusCode == 200) {
      return MisIglesia.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener la iglesia: ${response.statusCode}');
    }
  }

  // Crear nueva iglesia
  Future<Map<String, dynamic>> crearIglesia(
      MisIglesia iglesia, String token) async {
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/iglesias?api_token=$token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(iglesia.toJson()),
    );

    print(jsonEncode(iglesia.toJson()));

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonData;
    } else {
      // Verificar si es un error de validación
      if (response.statusCode == 422 &&
          responseData is Map<String, dynamic> &&
          responseData['success'] == false &&
          responseData.containsKey('errors')) {
        final errors = responseData['errors'] as Map<String, dynamic>;
        final errorMessage = StringBuffer();
        errorMessage.writeln(responseData['message'] ?? 'Error de validación');

        errors.forEach((field, messages) {
          if (messages is List) {
            for (final message in messages) {
              errorMessage.writeln('• $field: $message');
            }
          }
        });

        throw Exception(errorMessage.toString());
      } else {
        throw Exception(responseData['message'] ?? 'Error al crear iglesia');
      }
    }
  }

  // Actualizar iglesia
  Future<Map<String, dynamic>> actualizarIglesia(
      MisIglesia iglesia, String token) async {
    final response = await _httpClient.put(
      Uri.parse('$_baseUrl/iglesias/${iglesia.idIglesia}?api_token=$token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(iglesia.toJson()),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonData;
    } else {
      // Verificar si es un error de validación
      if (response.statusCode == 422 &&
          responseData is Map<String, dynamic> &&
          responseData['success'] == false &&
          responseData.containsKey('errors')) {
        final errors = responseData['errors'] as Map<String, dynamic>;
        final errorMessage = StringBuffer();
        errorMessage.writeln(responseData['message'] ?? 'Error de validación');

        errors.forEach((field, messages) {
          if (messages is List) {
            for (final message in messages) {
              errorMessage.writeln('• $field: $message');
            }
          }
        });

        throw Exception(errorMessage.toString());
      } else {
        throw Exception(
            responseData['message'] ?? 'Error al actualizar iglesia');
      }
    }
  }

  // Eliminar iglesia
  Future<void> eliminarIglesia(String id, String token) async {
    final response = await _httpClient.delete(
      Uri.parse('$_baseUrl/iglesias/$id/permanent?api_token=$token'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar iglesia: ${response.statusCode}');
    }
  }

  Future<void> subirImagenPortada(
      String iglesiaId, File imagen, String token) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/iglesias/$iglesiaId/imagenIglesia?api_token=$token'),
    );

    request.files.add(await http.MultipartFile.fromPath('imagen', imagen.path));

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Error al subir imagen de portada');
    }
  }

  Future<void> subirImagenGaleria(
      String iglesiaId, File imagen, String token) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          '$_baseUrl/iglesias/$iglesiaId/imagenesGaleria?api_token=$token'),
    );

    request.files.add(await http.MultipartFile.fromPath('imagen', imagen.path));

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Error al subir imagen a galería');
    }
  }

  Future<void> subirImagenesGaleria(
      String iglesiaId, List<File> imagenes, String token) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          '$_baseUrl/iglesias/$iglesiaId/imagenesGaleria?api_token=$token'),
    );

    for (var imagen in imagenes) {
      request.files.add(await http.MultipartFile.fromPath(
        'imagenes[]', // 👈 importante el []
        imagen.path,
      ));
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Error al subir imágenes a galería');
    }
  }

  Future<void> eliminarImagenGaleria(
      String idIglesia, String imagenId, String token) async {
    final response = await _httpClient.delete(
      Uri.parse(
          '$_baseUrl/iglesias/imagenes/$idIglesia/$imagenId?api_token=$token'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar imagen');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}

class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic> errors;
  final String formattedMessage;

  ValidationException({
    required this.message,
    required this.errors,
    required this.formattedMessage,
  });

  @override
  String toString() => formattedMessage;
}
