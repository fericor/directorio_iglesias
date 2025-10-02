class Actividad {
  int? idActividad;
  String? idRegistro;
  String? idOrganizacion;
  String? idIglesia;
  String? fechaHora;
  String? titulo;
  String? detalles;
  String? tipo;
  String? grupo;
  String? total;
  int? exitosas;
  int? fallidas;

  Actividad(
      {this.idActividad,
      this.idRegistro,
      this.idOrganizacion,
      this.idIglesia,
      this.fechaHora,
      this.titulo,
      this.detalles,
      this.tipo,
      this.grupo,
      this.total,
      this.exitosas,
      this.fallidas});

  Actividad.fromJson(Map<String, dynamic> json) {
    idActividad = json['idActividad'] ?? 0;
    idRegistro = json['idRegistro'].toString();
    idOrganizacion = json['idOrganizacion'].toString();
    idIglesia = json['idIglesia'].toString();
    fechaHora = json['fechaHora'];
    titulo = json['titulo'];
    detalles = json['detalles'];
    tipo = json['tipo'];
    grupo = json['grupo'];
    total = json['total'].toString() ?? "0";
    exitosas = json['exitosas'] ?? 0;
    fallidas = json['fallidas'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idActividad'] = this.idActividad;
    data['idRegistro'] = this.idRegistro;
    data['idOrganizacion'] = this.idOrganizacion;
    data['idIglesia'] = this.idIglesia;
    data['fechaHora'] = this.fechaHora;
    data['titulo'] = this.titulo;
    data['detalles'] = this.detalles;
    data['tipo'] = this.tipo;
    data['grupo'] = this.grupo;
    data['total'] = this.total;
    data['exitosas'] = this.exitosas;
    data['fallidas'] = this.fallidas;
    return data;
  }
}
