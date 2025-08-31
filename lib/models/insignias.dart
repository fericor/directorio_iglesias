import 'dart:convert';

class Insignia {
  final String nombre;
  final String icono;

  Insignia({required this.nombre, required this.icono});

  @override
  String toString() => '$nombre:$icono';
}

List<Insignia> parseInsigniasObjectsFromJson(String jsonString) {
  try {
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    final List<dynamic> insigniasList = jsonData['insignias'];

    return insigniasList.map((insignia) {
      return Insignia(nombre: insignia['nombre'], icono: insignia['icono']);
    }).toList();
  } catch (e) {
    print('Error parsing JSON: $e');
    return [];
  }
}
