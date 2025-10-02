import 'package:conexion_mas/models/Actividad.dart';
import 'package:conexion_mas/models/notificaciones.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificacionesApiClient {
  final String _baseUrl = MainUtils.urlHostApi;
  final http.Client _httpClient = http.Client();

  Future<List<Notificaciones>> getNotificaciones(String idUser, token) async {
    final response = await _httpClient.get(Uri.parse(
        '$_baseUrl/notificaciones/listarTodasByUser/$idUser?api_token=$token'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((jsonEventos) => Notificaciones.fromJson(jsonEventos))
          .toList();
    } else {
      throw Exception('Error al obtener la lista de eventos');
    }
  }

  ///////////////////////////////////
  /// Envía una notificación push mediante POST
  Future<Map<String, dynamic>> enviarNotificacionPush({
    required String title,
    required String bodyMsg,
    required Map<String, dynamic> data,
    required String tipo,
    required String grupo,
    required String token,
    required String idUser,
  }) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final url = Uri.parse('$_baseUrl/fcm/sendToUser?api_token=$token');
      final body = json.encode({
        "idUser": idUser,
        "title": title,
        "body": bodyMsg,
        "data": data,
        "tipo": tipo,
        "grupo": grupo,
      });

      final response = await http.post(url, headers: headers, body: body);

      // Verificar el código de respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Éxito
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'message': 'Notificación enviada exitosamente',
          'data': responseData,
          'statusCode': response.statusCode,
        };
      } else {
        // Error del servidor
        return {
          'success': false,
          'message': 'Error del servidor: ${response.statusCode}',
          'error': response.body,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      // Error de conexión o otro error
      return {
        'success': false,
        'message': 'Error al enviar notificación: $e',
        'error': e.toString(),
        'statusCode': 0,
      };
    }
  }

  Future<Map<String, dynamic>> enviarNotificacionPushById({
    required String title,
    required String bodyMsg,
    required Map<String, dynamic> data,
    required String tipo,
    required String grupo,
    required String token,
    required String idUser,
  }) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final url = Uri.parse('$_baseUrl/fcm/sendToUser?api_token=$token');
      final body = json.encode({
        "idUser": idUser,
        "title": title,
        "body": bodyMsg,
        "data": data,
        "tipo": tipo,
        "grupo": grupo,
      });

      final response = await http.post(url, headers: headers, body: body);

      // Verificar el código de respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Éxito
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'message': 'Notificación enviada exitosamente',
          'data': responseData,
          'statusCode': response.statusCode,
        };
      } else {
        // Error del servidor
        return {
          'success': false,
          'message': 'Error del servidor: ${response.statusCode}',
          'error': response.body,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      // Error de conexión o otro error
      return {
        'success': false,
        'message': 'Error al enviar notificación: $e',
        'error': e.toString(),
        'statusCode': 0,
      };
    }
  }

  Future<Map<String, dynamic>> enviarNotificacionPushByGenero({
    required String title,
    required String bodyMsg,
    required Map<String, dynamic> data,
    required String tipo,
    required String grupo,
    required String token,
    required String idUser,
  }) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final url = Uri.parse('$_baseUrl/fcm/sendToGenero?api_token=$token');
      final body = json.encode({
        "idUser": idUser,
        "title": title,
        "body": bodyMsg,
        "data": data,
        "tipo": tipo,
        "grupo": grupo,
      });

      print('$_baseUrl/fcm/sendToGenero?api_token=$token');
      print(json.encode({
        "idUser": idUser,
        "title": title,
        "body": bodyMsg,
        "data": data,
        "tipo": tipo,
        "grupo": grupo,
      }));

      final response = await http.post(url, headers: headers, body: body);

      // Verificar el código de respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Éxito
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'message': 'Notificación enviada exitosamente',
          'data': responseData,
          'statusCode': response.statusCode,
        };
      } else {
        // Error del servidor
        return {
          'success': false,
          'message': 'Error del servidor: ${response.statusCode}',
          'error': response.body,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      // Error de conexión o otro error
      return {
        'success': false,
        'message': 'Error al enviar notificación: $e',
        'error': e.toString(),
        'statusCode': 0,
      };
    }
  }

  Future<List<Actividad>> listarNotificaciones(String idIglesia, token) async {
    final response = await _httpClient
        .get(Uri.parse('$_baseUrl/fcm/listarNotificaciones?api_token=$token'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((jsonIglesias) => Actividad.fromJson(jsonIglesias))
          .toList();
    } else {
      throw Exception('Error al obtener la lista de iglesias');
    }
  }

  Future<List<Actividad>> listarNotificacionesByIglesia(
      String idIglesia, token) async {
    print(
        '$_baseUrl/fcm/listarNotificacionesByIglesia/$idIglesia?api_token=$token');
    final response = await _httpClient.get(Uri.parse(
        '$_baseUrl/fcm/listarNotificacionesByIglesia/$idIglesia?api_token=$token'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((jsonIglesias) => Actividad.fromJson(jsonIglesias))
          .toList();
    } else {
      throw Exception('Error al obtener la lista de iglesias');
    }
  }

  //////////////////////////////////
}
