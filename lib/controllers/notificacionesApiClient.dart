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
}
