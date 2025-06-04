class Eventos {
  int? idEvento;
  String? fecha;
  String? hora;
  String? fechaFin;
  String? horaFin;
  String? titulo;
  String? descripcion;
  String? etiqueta;
  String? tipo;
  String? descripcionCorta;
  String? imagen;
  int? portada;
  int? distrito;
  int? region;
  int? activo;

  Eventos({
    this.idEvento, 
    this.fecha, 
    this.hora, 
    this.fechaFin, 
    this.horaFin, 
    this.titulo, 
    this.descripcion,
    this.etiqueta,
    this.tipo,
    this.descripcionCorta,
    this.imagen,
    this.portada,
    this.distrito,
    this.region,
    this.activo,
   });

  factory Eventos.fromJson(Map<String, dynamic> json) {
    return Eventos(
      idEvento: json['idEvento'],
      fecha: json['fecha'],
      hora: json['hora'],
      fechaFin: json['fechaFin'],
      horaFin: json['horaFin'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      etiqueta: json['etiqueta'],
      tipo: json['tipo'],
      descripcionCorta: json['descripcionCorta'],
      imagen: json['imagen'],
      portada: json['portada'],
      distrito: json['distrito'],
      region: json['region'],
      activo: json['activo'],
    );
  }
}
