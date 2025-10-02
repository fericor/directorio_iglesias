class Notificaciones {
  int? idNotificacion;
  int? idUsuario;
  String? titulo;
  String? detalles;
  String? tipo;
  String? fecha;
  String? estado;
  String? createdAt;
  String? updatedAt;

  Notificaciones(
      {this.idNotificacion,
      this.idUsuario,
      this.titulo,
      this.detalles,
      this.tipo,
      this.fecha,
      this.estado,
      this.createdAt,
      this.updatedAt});

  Notificaciones.fromJson(Map<String, dynamic> json) {
    idNotificacion = json['idNotificacion'];
    idUsuario = json['idUsuario'];
    titulo = json['titulo'];
    detalles = json['detalles'];
    tipo = json['tipo'];
    fecha = json['fecha'];
    estado = json['estado'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idNotificacion'] = idNotificacion;
    data['idUsuario'] = idUsuario;
    data['titulo'] = titulo;
    data['detalles'] = detalles;
    data['tipo'] = tipo;
    data['fecha'] = fecha;
    data['estado'] = estado;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
