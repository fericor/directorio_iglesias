class Event {
  final int idEvento;
  final int idPais;
  final int idOrganizacion;
  final int idIglesia;
  final String fecha;
  final String hora;
  final String? fechaFin;
  final String? horaFin;
  final String titulo;
  final String? lugar;
  final String? direccion;
  final String? descripcionCorta;
  final String? descripcion;
  final String? infoExtra;
  final int? seats;
  final String tipo;
  final String? etiqueta;
  final String? imagen;
  final String? portada;
  final int orden;
  final String? distrito;
  final String? region;
  final bool esGratis;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.idEvento,
    required this.idPais,
    required this.idOrganizacion,
    required this.idIglesia,
    required this.fecha,
    required this.hora,
    this.fechaFin,
    this.horaFin,
    required this.titulo,
    this.lugar,
    this.direccion,
    this.descripcionCorta,
    this.descripcion,
    this.infoExtra,
    this.seats,
    required this.tipo,
    this.etiqueta,
    this.imagen,
    this.portada,
    required this.orden,
    this.distrito,
    this.region,
    required this.esGratis,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      idEvento: json['idEvento'],
      idPais: json['idPais'],
      idOrganizacion: json['idOrganizacion'],
      idIglesia: json['idIglesia'],
      fecha: json['fecha'],
      hora: json['hora'],
      fechaFin: json['fechaFin'],
      horaFin: json['horaFin'],
      titulo: json['titulo'],
      lugar: json['lugar'],
      direccion: json['direccion'],
      descripcionCorta: json['descripcionCorta'],
      descripcion: json['descripcion'],
      infoExtra: json['infoExtra'],
      seats: json['seats'],
      tipo: json['tipo'],
      etiqueta: json['etiqueta'],
      imagen: json['imagen'],
      portada: json['portada'],
      orden: json['orden'],
      distrito: json['distrito'],
      region: json['region'],
      esGratis: json['esGratis'] == 1,
      activo: json['activo'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
