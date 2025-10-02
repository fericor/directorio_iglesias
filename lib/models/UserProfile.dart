class UserProfile {
  final int id;
  final String nombre;
  final String apellidos;
  final String email;
  final String? fotoPerfil;
  final String? biografia;
  final DateTime nacimiento;
  final String genero;
  final String telefono;
  final List<int> iglesiasFavoritas;
  final List<int> eventosFavoritos;
  final int seguidores;
  final int siguiendo;

  UserProfile({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.email,
    this.fotoPerfil,
    this.biografia,
    required this.nacimiento,
    required this.genero,
    required this.telefono,
    required this.iglesiasFavoritas,
    required this.eventosFavoritos,
    required this.seguidores,
    required this.siguiendo,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      email: json['email'],
      fotoPerfil: json['foto_perfil'],
      biografia: json['biografia'],
      nacimiento: DateTime.parse(json['nacimiento']),
      genero: json['genero'],
      telefono: json['telefono'],
      iglesiasFavoritas: List<int>.from(json['iglesias_favoritas'] ?? []),
      eventosFavoritos: List<int>.from(json['eventos_favoritos'] ?? []),
      seguidores: json['seguidores'] ?? 0,
      siguiendo: json['siguiendo'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellidos': apellidos,
      'email': email,
      'foto_perfil': fotoPerfil,
      'biografia': biografia,
      'nacimiento': nacimiento.toIso8601String(),
      'genero': genero,
      'telefono': telefono,
    };
  }
}
