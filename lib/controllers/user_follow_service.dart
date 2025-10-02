import 'dart:convert';

import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:http/http.dart' as http;

class UserFollowService {
  // Seguir a un usuario
  static Future<http.Response> followUser(int userId, String token) async {
    try {
      final response = await http.post(
          Uri.parse('${MainUtils.urlHostApi}/seguimiento?api_token=$token'),
          body: {
            'tipo': 'usuario',
            'idUsuario': userId.toString(),
          });

      return response;
    } catch (error) {
      throw Exception('Error al seguir usuario: $error');
    }
  }

  // Dejar de seguir a un usuario
  static Future<http.Response> unfollowUser(int userId, String token) async {
    try {
      final response = await http.delete(
          Uri.parse('${MainUtils.urlHostApi}/seguimiento?api_token=$token'),
          body: {
            'tipo': 'usuario',
            'idUsuario': userId.toString(),
          });
      return response;
    } catch (error) {
      throw Exception('Error al dejar de seguir usuario: $error');
    }
  }

  // Verificar si se sigue a un usuario
  static Future<bool> checkIfFollowingUser(int userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${MainUtils.urlHostApi}/seguimiento/verificar?tipo=usuario&idUsuario=$userId&api_token=$token'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Aseguramos que exista la clave
        return data['data']?['siguiendo'] ?? false;
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error al verificar seguimiento: $error');
    }
  }

  // Obtener seguidores de un usuario
  static Future<List<dynamic>> getUserFollowers(
      int userId, String token) async {
    try {
      final response = await http.get(Uri.parse(
          '${MainUtils.urlHostApi}/usuario/$userId/seguidores?api_token=$token'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Aseguramos que exista la clave
        return data['data'] ?? [];
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error al obtener seguidores: $error');
    }
  }

  // Obtener usuarios que sigue un usuario
  static Future<List<dynamic>> getUserFollowing(
      int userId, String token) async {
    try {
      final response = await http.get(Uri.parse(
          '${MainUtils.urlHostApi}/usuario/$userId/siguiendo?api_token=$token'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Aseguramos que exista la clave
        return data['data'] ?? [];
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error al obtener seguidos: $error');
    }
  }
}
