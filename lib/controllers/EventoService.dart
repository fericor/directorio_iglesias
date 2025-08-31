import 'dart:convert';
import 'package:conexion_mas/models/MisEventos.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:http/http.dart' as http;

class EventoService {
  final String _baseUrl = MainUtils.urlHostApi;
  final http.Client _httpClient = http.Client();

  Future<List<MisEventos>> getEventoByIglesia(
      String idIglesia, String token) async {
    final response = await _httpClient
        .get(Uri.parse('$_baseUrl/eventos/$idIglesia?api_token=$token'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((jsonEventos) => MisEventos.fromJson(jsonEventos))
          .toList();
    } else {
      throw Exception('Error al obtener la tarea con ID $idIglesia');
    }
  }

  Future<String> subirImagenEvento(
      int eventoId, List<int> imageBytes, String fileName, String token) async {
    try {
      // Crear la solicitud multipart
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/eventos/$eventoId/upload-image?api_token=$token'),
      );

      // Agregar la imagen al request
      request.files.add(http.MultipartFile.fromBytes(
        'imagen', // Nombre del campo en el servidor
        imageBytes,
        filename: fileName,
      ));

      // Enviar la solicitud
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody);
        return jsonResponse['imageUrl'] ?? jsonResponse['imagen'] ?? '';
      } else {
        throw Exception('Error al subir la imagen: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al subir la imagen: $e');
    }
  }

  // Versión alternativa usando put si tu API lo requiere
  Future<String> subirImagenEventoPut(
      int eventoId, List<int> imageBytes, String fileName, String token) async {
    try {
      // Crear la solicitud multipart
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$_baseUrl/eventos/$eventoId/image?api_token=$token'),
      );

      // Agregar la imagen al request
      request.files.add(http.MultipartFile.fromBytes(
        'imagen',
        imageBytes,
        filename: fileName,
      ));

      // Enviar la solicitud
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody);
        return jsonResponse['imageUrl'] ?? jsonResponse['imagen'] ?? '';
      } else {
        throw Exception('Error al subir la imagen: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al subir la imagen: $e');
    }
  }

  // Versión con JSON (si tu API acepta base64)
  Future<String> subirImagenEventoBase64(
      int eventoId, List<int> imageBytes, String fileName, String token) async {
    try {
      final base64Image = base64Encode(imageBytes);

      final response = await _httpClient.put(
        Uri.parse('$_baseUrl/eventos/$eventoId/image?api_token=$token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'imagen': base64Image,
          'nombre_archivo': fileName,
          'formato': fileName.split('.').last,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['imageUrl'] ?? jsonResponse['imagen'] ?? '';
      } else {
        throw Exception('Error al subir la imagen: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al subir la imagen: $e');
    }
  }

  // Método editarEvento en el mismo estilo
  Future<void> editarEvento(MisEventos evento, String token) async {
    final response = await _httpClient.put(
      Uri.parse('$_baseUrl/eventos/${evento.idEvento}?api_token=$token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(evento.toJson()),
    );

    if (response.statusCode == 200) {
      // El evento se actualizó correctamente
    } else {
      throw Exception('Error al actualizar el evento: ${response.statusCode}');
    }
  }

  // Método crearEvento en el mismo estilo
  Future<MisEventos> crearEvento(MisEventos evento, String token) async {
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/eventos?api_token=$token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(evento.toJson()),
    );

    print("Valor: ");
    print(response.body);

    if (response.statusCode == 200) {
      return MisEventos.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear el evento: ${response.statusCode}');
    }
  }

  // Método eliminarEvento
  Future<void> eliminarEvento(String idEvento, String token) async {
    final response = await _httpClient.delete(
      Uri.parse('$_baseUrl/eventos/$idEvento?api_token=$token'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el evento: ${response.statusCode}');
    }
  }

  // Cerrar el cliente HTTP cuando ya no se necesite
  void dispose() {
    _httpClient.close();
  }
}
