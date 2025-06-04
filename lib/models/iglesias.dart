class Iglesias {
  int? idIglesia;
  String? titulo;
  String? direccion;
  String? comunidad;
  String? provincia;
  String? ciudad;
  String? distrito;
  String? region;
  String? zona;
  String? descripcion;
  String? valoracion;
  double? latitud;
  double? longitud;
  String? telefono;
  String? web;
  int? activo;
  Null createdAt;
  Null updatedAt;

  Iglesias(
      {this.idIglesia,
      this.titulo,
      this.direccion,
      this.comunidad,
      this.provincia,
      this.ciudad,
      this.distrito,
      this.region,
      this.zona,
      this.descripcion,
      this.valoracion,
      this.latitud,
      this.longitud,
      this.telefono,
      this.web,
      this.activo,
      this.createdAt,
      this.updatedAt});

  Iglesias.fromJson(Map<String, dynamic> json) {
    idIglesia = json['idIglesia'];
    titulo = json['titulo'];
    direccion = json['direccion'];
    comunidad = json['comunidad'];
    provincia = json['provincia'];
    ciudad = json['ciudad'];
    distrito = json['distrito'];
    region = json['region'];
    zona = json['zona'];
    descripcion = json['descripcion'];
    valoracion = json['valoracion'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    telefono = json['telefono'];
    web = json['web'];
    activo = json['activo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idIglesia'] = idIglesia;
    data['titulo'] = titulo;
    data['direccion'] = direccion;
    data['comunidad'] = comunidad;
    data['provincia'] = provincia;
    data['ciudad'] = ciudad;
    data['distrito'] = distrito;
    data['region'] = region;
    data['zona'] = zona;
    data['descripcion'] = descripcion;
    data['valoracion'] = valoracion;
    data['latitud'] = latitud;
    data['longitud'] = longitud;
    data['telefono'] = telefono;
    data['web'] = web;
    data['activo'] = activo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
