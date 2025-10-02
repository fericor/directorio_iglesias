import 'dart:convert';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  static final String baseUrl = MainUtils.urlHostApi;
  static String? _authToken;

  static void setAuthToken(String token) {
    _authToken = token;
  }

  static Future<Map<String, dynamic>> _handleResponse(
      http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  static Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    };
  }

  // Perfil de usuario
  static Future<Map<String, dynamic>> getUserProfile(int? userId) async {
    final endpoint = '$baseUrl/mi-perfil?api_token=$_authToken';

    final response = await http.get(
      Uri.parse(endpoint),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Actualizar perfil
  static Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/mi-perfil?api_token=$_authToken'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // Comentarios
  static Future<Map<String, dynamic>> getComments(
      int? idIglesia, int? idEvento, String tipo) async {
    String url = '$baseUrl/comentarios?api_token=$_authToken&tipo=$tipo';
    if (idIglesia != null) url += '&idIglesia=$idIglesia';
    if (idEvento != null) url += '&idEvento=$idEvento';

    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> addComment(
      Map<String, dynamic> commentData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/comentarios?api_token=$_authToken'),
      headers: await _getHeaders(),
      body: json.encode(commentData),
    );

    print('$baseUrl/comentarios?api_token=$_authToken');
    print(json.encode(commentData));

    return _handleResponse(response);
  }

  // Seguimiento/Favoritos
  static Future<Map<String, dynamic>> checkFollowing(
      int? idIglesia, int? idEvento, String tipo) async {
    String url =
        '$baseUrl/seguimiento/verificar?api_token=$_authToken&tipo=$tipo';
    if (idIglesia != null) url += '&idIglesia=$idIglesia';
    if (idEvento != null) url += '&idEvento=$idEvento';

    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> follow(
      Map<String, dynamic> followData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/seguimiento?api_token=$_authToken'),
      headers: await _getHeaders(),
      body: json.encode(followData),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> unfollow(
      int? idIglesia, int? idEvento, String tipo) async {
    String url = '$baseUrl/seguimiento?api_token=$_authToken&tipo=$tipo';
    if (idIglesia != null) url += '&idIglesia=$idIglesia';
    if (idEvento != null) url += '&idEvento=$idEvento';

    final response = await http.delete(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  // Eventos recomendados
  static Future<Map<String, dynamic>> getRecommendedEvents() async {
    final response = await http.get(
      Uri.parse('$baseUrl/eventos/recomendados?api_token=$_authToken'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  // Eventos favoritos
  static Future<Map<String, dynamic>> getFavoriteEvents() async {
    final response = await http.get(
      Uri.parse('$baseUrl/eventos/favoritos?api_token=$_authToken'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  // Obtener seguidores de un usuario
  // Obtener todos los usuarios (con paginación)
  static Future<Map<String, dynamic>> getAllUsers(
      {int page = 1, int limit = 20}) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/usuarios?page=$page&limit=$limit&api_token=$_authToken'));
      return _handleResponse(response);
    } catch (error) {
      throw Exception('Error al obtener usuarios: $error');
    }
  }

  // Obtener miembros de una iglesia
  static Future<Map<String, dynamic>> getChurchMembers(int churchId) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/iglesias/$churchId/miembros?api_token=$_authToken'));
      return _handleResponse(response);
    } catch (error) {
      throw Exception('Error al obtener miembros: $error');
    }
  }

  // Obtener asistentes a un evento
  static Future<Map<String, dynamic>> getEventAttendees(int eventId) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/eventos/$eventId/asistentes?api_token=$_authToken'));
      return _handleResponse(response);
    } catch (error) {
      throw Exception('Error al obtener asistentes: $error');
    }
  }

  // Obtener seguidores de un usuario
  static Future<Map<String, dynamic>> getUserFollowers(int userId) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/usuario/$userId/seguidores?api_token=$_authToken'));
      return _handleResponse(response);
    } catch (error) {
      throw Exception('Error al obtener seguidores: $error');
    }
  }

  // Obtener usuarios que sigue un usuario
  static Future<Map<String, dynamic>> getUserFollowing(int userId) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/usuario/$userId/siguiendo?api_token=$_authToken'));
      return _handleResponse(response);
    } catch (error) {
      throw Exception('Error al obtener seguidos: $error');
    }
  }

  // Buscar usuarios por nombre o email
  static Future<Map<String, dynamic>> searchUsers(String query) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/usuarios/buscar?q=${Uri.encodeComponent(query)}&api_token=$_authToken'));
      return _handleResponse(response);
    } catch (error) {
      throw Exception('Error al buscar usuarios: $error');
    }
  }

  // Obtener usuarios sugeridos (basado en intereses, ubicación, etc.)
  static Future<Map<String, dynamic>> getSuggestedUsers() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/usuarios/sugeridos?api_token=$_authToken'));
      return _handleResponse(response);
    } catch (error) {
      throw Exception('Error al obtener usuarios sugeridos: $error');
    }
  }

  ////////////////////////////////////////////////////
}
