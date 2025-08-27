import 'package:conexion_mas/models/iglesia.dart';
import 'package:conexion_mas/models/iglesias.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IglesiasApiClient {
  final String _baseUrl = MainUtils.urlHostApi;
  final http.Client _httpClient = http.Client();

  Future<List<Iglesia>> obtenerIglesias() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/frcaListarIglesias'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Iglesia.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar las iglesias: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<Iglesias>> getIglesiasCerca(
      String latitud, longitud, distancia) async {
    final response = await _httpClient.get(Uri.parse(
        '$_baseUrl/frcaListarIglesiasCerca/$latitud/$longitud/$distancia'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((jsonIglesias) => Iglesias.fromJson(jsonIglesias))
          .toList();
    } else {
      throw Exception('Error al obtener la lista de iglesias');
    }
  }

  Future<List<Iglesias>> getIglesiass() async {
    final response =
        await _httpClient.get(Uri.parse('$_baseUrl/frcaListarIglesias'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((jsonIglesias) => Iglesias.fromJson(jsonIglesias))
          .toList();
    } else {
      throw Exception('Error al obtener la lista de iglesias');
    }
  }

  Future<Iglesias> getIglesias(int id) async {
    final response =
        await _httpClient.get(Uri.parse('$_baseUrl/Iglesiass/$id'));
    if (response.statusCode == 200) {
      return Iglesias.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener la tarea con ID $id');
    }
  }

  Future<void> createIglesias(Iglesias Iglesias) async {
    final response = await _httpClient.post(Uri.parse('$_baseUrl/Iglesiass'),
        body: jsonEncode(Iglesias));
    if (response.statusCode == 201) {
      // La tarea se creó correctamente
    } else {
      throw Exception('Error al crear la tarea');
    }
  }

  Future<void> updateIglesias(Iglesias Iglesias) async {
    final response = await _httpClient.put(
        Uri.parse('$_baseUrl/Iglesiass/${Iglesias.idIglesia}'),
        body: jsonEncode(Iglesias));
    if (response.statusCode == 200) {
      // La tarea se actualizó correctamente
    } else {
      throw Exception('Error al actualizar la tarea');
    }
  }

  Future<void> deleteIglesias(int id) async {
    final response =
        await _httpClient.delete(Uri.parse('$_baseUrl/Iglesiass/$id'));
    if (response.statusCode == 200) {
      // La tarea se eliminó correctamente
    } else {
      throw Exception('Error al eliminar la tarea con ID $id');
    }
  }
}
