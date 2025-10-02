class Comment {
  final int id;
  final int idUsuario;
  final String userName;
  final String? userFoto;
  final int? idIglesia;
  final int? idEvento;
  final String tipo;
  final String comentario;
  final int calificacion;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment({
    required this.id,
    required this.idUsuario,
    required this.userName,
    this.userFoto,
    this.idIglesia,
    this.idEvento,
    required this.tipo,
    required this.comentario,
    required this.calificacion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      idUsuario: json['idUsuario'],
      userName: json['userName'] ?? 'Usuario',
      userFoto: json['userFoto'],
      idIglesia: json['idIglesia'],
      idEvento: json['idEvento'],
      tipo: json['tipo'],
      comentario: json['comentario'],
      calificacion: json['calificacion'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  String get fecha {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} días';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minutos';
    } else {
      return 'Ahora mismo';
    }
  }
}
