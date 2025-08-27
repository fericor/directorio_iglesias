// services/api_service.dart
import 'dart:convert';
import 'package:conexion_mas/models/reservas.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:http/http.dart' as http;

class ReservasApiClient {
  static final String baseUrl = MainUtils.urlHostApi; // Cambia por tu URL
  static String apiToken = '';

  static Map<String, String> get headers {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (apiToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $apiToken';
    }

    return headers;
  }

  static void setApiToken(String token) {
    apiToken = token;
  }

  // Crear una reserva con múltiples items
  static Future<Map<String, dynamic>> crearReserva({
    required int idEvento,
    required int idUsuario,
    int? idAsiento,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/reservas?api_token=$apiToken');
      final body = json.encode({
        'idEvento': idEvento,
        'idUsuario': idUsuario,
        if (idAsiento != null) 'idAsiento': idAsiento,
        'items': items,
      });

      print('$baseUrl/reservas?api_token=$apiToken');
      print(body);

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'reserva': Reserva.fromJson(data['reserva']),
          'message': data['message'] ?? 'Reserva creada exitosamente',
        };
      } else {
        return {
          'success': false,
          'error': _handleError(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  // Cancelar reserva
  static Future<Map<String, dynamic>> cancelarReserva(
      String codigoReserva) async {
    try {
      final url = Uri.parse(
          '$baseUrl/reservas/$codigoReserva/cancelar?api_token=$apiToken');
      final response = await http.put(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Reserva cancelada exitosamente',
        };
      } else {
        return {
          'success': false,
          'error': _handleError(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  // Obtener items disponibles de un evento
  static Future<Map<String, dynamic>> obtenerItemsEvento(int idEvento) async {
    try {
      final url = Uri.parse('$baseUrl/eventos/$idEvento/items');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = (data['items_disponibles'] as List)
            .map((item) => EventoItem.fromJson(item))
            .toList();

        return {
          'success': true,
          'items': items,
          'evento': data['evento'] ?? '',
        };
      } else {
        return {
          'success': false,
          'error': _handleError(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  // Obtener reservas de usuario
  static Future<Map<String, dynamic>> obtenerReservasUsuario(
      String idUsuario) async {
    try {
      final url = Uri.parse(
          '$baseUrl/usuarios/${idUsuario.toString()}/reservas?api_token=$apiToken');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reservas = (data['reservas'] as List)
            .map((item) => Reserva.fromJson(item))
            .toList();

        return {
          'success': true,
          'reservas': reservas,
        };
      } else {
        return {
          'success': false,
          'error': _handleError(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error: $e',
      };
    }
  }

  // Ver disponibilidad de evento
  static Future<Map<String, dynamic>> verDisponibilidadEvento(
      int idEvento) async {
    try {
      final url = Uri.parse('$baseUrl/eventos/$idEvento/disponibilidad');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'disponibilidad': DisponibilidadEvento.fromJson(data),
        };
      } else {
        return {
          'success': false,
          'error': _handleError(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  // Obtener asientos disponibles
  static Future<Map<String, dynamic>> obtenerAsientosDisponibles(
      int idEvento) async {
    try {
      final url = Uri.parse('$baseUrl/eventos/$idEvento/asientos');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final asientos = (data['asientos_disponibles'] as List)
            .map((item) => Asiento.fromJson(item))
            .toList();

        return {
          'success': true,
          'asientos': asientos,
          'totalDisponible': data['total_disponible'] ?? 0,
        };
      } else {
        return {
          'success': false,
          'error': _handleError(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  // Obtener información de asiento
  static Future<Map<String, dynamic>> obtenerInfoAsiento(int idAsiento) async {
    try {
      final url = Uri.parse('$baseUrl/asientos/$idAsiento');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'asiento': Asiento.fromJson(data['asiento']),
        };
      } else {
        return {
          'success': false,
          'error': _handleError(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  // Obtener detalles de reserva
  static Future<Map<String, dynamic>> obtenerDetalleReserva(
      String codigoReserva) async {
    try {
      final url = Uri.parse('$baseUrl/reservas/$codigoReserva');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'reserva': Reserva.fromJson(data['reserva']),
        };
      } else {
        return {
          'success': false,
          'error': _handleError(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  // Manejar errores de la API
  static String _handleError(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      return errorData['message'] ??
          errorData['error'] ??
          'Error ${response.statusCode}: ${response.reasonPhrase}';
    } catch (e) {
      return 'Error ${response.statusCode}: ${response.reasonPhrase}';
    }
  }
}
