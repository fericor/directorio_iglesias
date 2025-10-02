import 'dart:convert';
import 'package:conexion_mas/models/MisEventosItems.dart';
import 'package:http/http.dart' as http;

class MisEventoItemService {
  final String _baseUrl;
  final http.Client _httpClient;

  MisEventoItemService({required String baseUrl, http.Client? httpClient})
      : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client();

  // Obtener items de un evento - Devuelve la respuesta completa
  Future<EventoItemsResponse> getItemsByEvento(
      String idEvento, String token) async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/eventos/$idEvento/items?api_token=$token'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return EventoItemsResponse.fromJson(data);
    } else {
      throw Exception('Error al obtener items: ${response.statusCode}');
    }
  }

  // Crear nuevo item
  Future<MisEventoItem> crearItem(MisEventoItem item, String token) async {
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/eventos/items?api_token=$token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode == 201) {
      return MisEventoItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear item: ${response.statusCode}');
    }
  }

  // Actualizar item existente
  Future<MisEventoItem> actualizarItem(MisEventoItem item, String token) async {
    final response = await _httpClient.put(
      Uri.parse('$_baseUrl/eventos/items/${item.id}?api_token=$token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode == 200) {
      return MisEventoItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar item: ${response.statusCode}');
    }
  }

  // Eliminar item
  Future<void> eliminarItem(String id, String token) async {
    final response = await _httpClient.delete(
      Uri.parse('$_baseUrl/eventos/items/$id?api_token=$token'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar item: ${response.statusCode}');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
