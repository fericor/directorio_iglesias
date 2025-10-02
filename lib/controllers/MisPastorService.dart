import 'dart:convert';
import 'package:conexion_mas/models/Pastores.dart';
import 'package:http/http.dart' as _client;

class MisPastorService {
  final String _baseUrl;
  final _client.Client _httpClient;

  MisPastorService({required String baseUrl, _client.Client? httpClient})
      : _baseUrl = baseUrl,
        _httpClient = httpClient ?? _client.Client();

  // Obtener todos los pastores
  Future<List<Pastores>> getPastoresByOrganizacion(
      String token, String idOrganizacion) async {
    try {
      final response = await _client.get(Uri.parse(
          '$_baseUrl/pastoresByOrganizacion/$idOrganizacion?api_token=$token'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Pastores.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener pastores: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<Pastores>> getPastores(String token) async {
    try {
      final response = await _client.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Pastores.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener pastores: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener pastor por ID
  Future<Pastores> obtenerPastorPorId(String id) async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/$id'));

      if (response.statusCode == 200) {
        return Pastores.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener pastor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Crear nuevo pastor
  Future<Pastores> crearPastor(Pastores pastor) async {
    try {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pastor.toJson()),
      );

      if (response.statusCode == 201) {
        return Pastores.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear pastor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Actualizar pastor
  Future<Pastores> actualizarPastor(Pastores pastor) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/${pastor.idPastor}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pastor.toJson()),
      );

      if (response.statusCode == 200) {
        return Pastores.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar pastor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Eliminar pastor
  Future<void> eliminarPastor(String id) async {
    try {
      final response = await _client.delete(Uri.parse('$_baseUrl/$id'));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar pastor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Buscar pastores por nombre
  Future<List<Pastores>> buscarPastores(String query) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/buscar?q=$query'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Pastores.fromJson(json)).toList();
      } else {
        throw Exception('Error en la búsqueda: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
