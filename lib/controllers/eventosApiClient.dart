import 'package:conexion_mas/models/categorias.dart';
import 'package:conexion_mas/models/eventos.dart';
import 'package:conexion_mas/models/eventosItems.dart';
import 'package:conexion_mas/models/misreservas.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventosApiClient {
  final String _baseUrl = MainUtils.urlHostApi;
  final http.Client _httpClient = http.Client();

  Future<void> updateSeat(String idEvento, String idUsuario, int fila,
      int columna, int valor, String token) async {
    // Realizamos la solicitud POST
    final response = await _httpClient.get(Uri.parse(
        '$_baseUrl/eventos/$idEvento/asiento/$fila/$columna/$valor/$idUsuario?api_token=$token'));

    // Revisamos la respuesta
    if (response.statusCode == 200) {
      // Si la solicitud fue exitosa, puedes manejar la respuesta si es necesario
    } else {
      // Si algo salió mal
      throw Exception('Error al actualizar el asiento: ${response.body}');
    }
  }

  Future<List<Eventos>> getEventoss() async {
    final response =
        await _httpClient.get(Uri.parse('$_baseUrl/frcaListarEventos'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((jsonEventos) => Eventos.fromJson(jsonEventos))
          .toList();
    } else {
      throw Exception('Error al obtener la lista de eventos');
    }
  }

  Future<List<Eventos>> getEventosIglesia(int idIglesia) async {
    final response = await _httpClient
        .get(Uri.parse('$_baseUrl/frcaListarEventosIglesia/$idIglesia'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((jsonEventos) => Eventos.fromJson(jsonEventos))
          .toList();
    } else {
      throw Exception('Error al obtener la lista de eventos');
    }
  }

  Future<List<Categorias>> getEventosCategorias() async {
    final response = await _httpClient
        .get(Uri.parse('$_baseUrl/frcaListarEventoscategorias'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((jsonEventos) => Categorias.fromJson(jsonEventos))
          .toList();
    } else {
      throw Exception('Error al obtener la lista de eventos');
    }
  }

  Future<List<Eventos>> getEventosRegion(String idRegion) async {
    final response = await _httpClient
        .get(Uri.parse('$_baseUrl/frcaListarEventosRegion/$idRegion'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((jsonEventos) => Eventos.fromJson(jsonEventos))
          .toList();
    } else {
      throw Exception('Error al obtener la lista de eventos');
    }
  }

  Future<EventosItems> getEventoById(int id) async {
    final response =
        await _httpClient.get(Uri.parse('$_baseUrl/frcaListarEventosById/$id'));
    if (response.statusCode == 200) {
      return EventosItems.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener la tarea con ID $id');
    }
  }

  Future<EventosItems> getEventoByIdByUser(int id, String idUser) async {
    final response = await _httpClient
        .get(Uri.parse('$_baseUrl/frcaListarEventosByIdByUser/$id/$idUser'));
    if (response.statusCode == 200) {
      return EventosItems.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener la tarea con ID $id');
    }
  }

  Future<List<MisReservas>> getEventoByUser(
      String idUser, String apiToken) async {
    final response = await _httpClient.get(Uri.parse(
        '$_baseUrl/frcaListarEventosByUser/$idUser?api_token=$apiToken'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((jsonEventos) => MisReservas.fromJson(jsonEventos))
          .toList();
    } else {
      throw Exception('Error al obtener la lista de eventos');
    }
  }

  Future<EventoSeatsResponse> getEventoSeatsById(int id) async {
    final response = await _httpClient
        .get(Uri.parse('$_baseUrl/frcaListarEventosSeats/$id'));

    if (response.statusCode == 200) {
      // Utilizamos EventoSeatsResponse para parsear la respuesta JSON
      return EventoSeatsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener la tarea con ID $id');
    }
  }

  Future<EventosItems> getEventoPortada() async {
    final response =
        await _httpClient.get(Uri.parse('$_baseUrl/frcaListarEventoPortada'));
    if (response.statusCode == 200) {
      return EventosItems.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener los eventos de portada');
    }
  }

  Future<void> createEventos(Eventos Eventos) async {
    final response = await _httpClient.post(Uri.parse('$_baseUrl/Eventoss'),
        body: jsonEncode(Eventos));
    if (response.statusCode == 201) {
      // La tarea se creó correctamente
    } else {
      throw Exception('Error al crear la tarea');
    }
  }

  Future<void> updateEventos(Eventos Eventos) async {
    final response = await _httpClient.put(
        Uri.parse('$_baseUrl/Eventoss/${Eventos.idEvento}'),
        body: jsonEncode(Eventos));
    if (response.statusCode == 200) {
      // La tarea se actualizó correctamente
    } else {
      throw Exception('Error al actualizar la tarea');
    }
  }

  Future<void> deleteEventos(int id) async {
    final response =
        await _httpClient.delete(Uri.parse('$_baseUrl/Eventoss/$id'));
    if (response.statusCode == 200) {
      // La tarea se eliminó correctamente
    } else {
      throw Exception('Error al eliminar la tarea con ID $id');
    }
  }
}

class EventoSeatsResponse {
  final List<List<int>> seats;

  EventoSeatsResponse({required this.seats});

  // Método para crear una instancia de EventoSeatsResponse a partir de un JSON
  factory EventoSeatsResponse.fromJson(Map<String, dynamic> json) {
    var seatsJson = json['seats'] as List;
    List<List<int>> seatsList = seatsJson.map((row) {
      return List<int>.from(row);
    }).toList();

    return EventoSeatsResponse(seats: seatsList);
  }
}
