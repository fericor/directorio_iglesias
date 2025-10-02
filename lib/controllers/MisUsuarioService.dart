import 'dart:convert';
import 'package:conexion_mas/models/MisUsuarios.dart';
import 'package:http/http.dart' as http;

class MisUsuarioService {
  final String baseUrl;
  final String token;
  MisUsuarioService(this.baseUrl, {required this.token});

  Future<List<MisUsuario>> getUsuarios({int? idIglesia}) async {
    final uri = idIglesia != null
        ? Uri.parse('$baseUrl/usuarios?iglesia=$idIglesia&api_token=$token')
        : Uri.parse('$baseUrl/usuarios?api_token=$token');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => MisUsuario.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener usuarios: ${response.body}");
    }
  }

  Future<MisUsuario> getUsuarioById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/usuarios/$id'));
    if (response.statusCode == 200) {
      return MisUsuario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error al obtener usuario: ${response.body}");
    }
  }

  Future<MisUsuario> createUsuario(MisUsuario usuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/MisUsuarios?api_token=$token'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(usuario.toJson()),
    );
    
    if (response.statusCode == 201) {
      return MisUsuario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error al crear usuario: ${response.body}");
    }
  }

  Future<MisUsuario> updateUsuario(MisUsuario usuario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/MisUsuarios/${usuario.id}?api_token=$token'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(usuario.toJson()),
    );

    print('$baseUrl/MisUsuarios/${usuario.id}?api_token=$token');
    print(jsonEncode(usuario.toJson()));

    if (response.statusCode == 200) {
      return MisUsuario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error al actualizar usuario: ${response.body}");
    }
  }

  Future<bool> deleteUsuario(int id) async {
    final response = await http
        .delete(Uri.parse('$baseUrl/MisUsuarios/$id?api_token=$token'));
    return response.statusCode == 200;
  }
}
