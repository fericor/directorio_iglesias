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
  String? activo;
  String? distanceKm;
  List<EventosIglesia>? eventosIglesia;

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
      this.distanceKm,
      this.eventosIglesia});

  Iglesias.fromJson(Map<String, dynamic> json) {
    idIglesia = json['idIglesia'];
    titulo = json['titulo'].toString();
    direccion = json['direccion'].toString();
    comunidad = json['comunidad'].toString();
    provincia = json['provincia'].toString();
    ciudad = json['ciudad'].toString();
    distrito = json['distrito'].toString();
    region = json['region'].toString();
    zona = json['zona'].toString();
    descripcion = json['descripcion'].toString();
    valoracion = json['valoracion'].toString();
    latitud = json['latitud'];
    longitud = json['longitud'];
    telefono = json['telefono'].toString();
    web = json['web'].toString();
    activo = json['activo'].toString();
    distanceKm = json['distance_km'].toString();
    if (json['eventosIglesia'] != null) {
      eventosIglesia = <EventosIglesia>[];
      json['eventosIglesia'].forEach((v) {
        eventosIglesia!.add(new EventosIglesia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idIglesia'] = this.idIglesia;
    data['titulo'] = this.titulo;
    data['direccion'] = this.direccion;
    data['comunidad'] = this.comunidad;
    data['provincia'] = this.provincia;
    data['ciudad'] = this.ciudad;
    data['distrito'] = this.distrito;
    data['region'] = this.region;
    data['zona'] = this.zona;
    data['descripcion'] = this.descripcion;
    data['valoracion'] = this.valoracion;
    data['latitud'] = this.latitud;
    data['longitud'] = this.longitud;
    data['telefono'] = this.telefono;
    data['web'] = this.web;
    data['activo'] = this.activo;
    data['distance_km'] = this.distanceKm;
    if (this.eventosIglesia != null) {
      data['eventosIglesia'] =
          this.eventosIglesia!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventosIglesia {
  String? idEvento;
  String? idOrganizacion;
  String? idIglesia;
  String? fecha;
  String? hora;
  String? fechaFin;
  String? horaFin;
  String? titulo;
  String? lugar;
  String? direccion;
  String? descripcionCorta;
  String? descripcion;
  String? seats;
  String? tipo;
  String? etiqueta;
  String? imagen;
  String? portada;
  String? distrito;
  String? region;
  String? activo;
  String? createdAt;
  String? updatedAt;

  EventosIglesia(
      {this.idEvento,
      this.idOrganizacion,
      this.idIglesia,
      this.fecha,
      this.hora,
      this.fechaFin,
      this.horaFin,
      this.titulo,
      this.lugar,
      this.direccion,
      this.descripcionCorta,
      this.descripcion,
      this.seats,
      this.tipo,
      this.etiqueta,
      this.imagen,
      this.portada,
      this.distrito,
      this.region,
      this.activo,
      this.createdAt,
      this.updatedAt});

  EventosIglesia.fromJson(Map<String, dynamic> json) {
    idEvento = json['idEvento'].toString();
    idOrganizacion = json['idOrganizacion'].toString();
    idIglesia = json['idIglesia'].toString();
    fecha = json['fecha'].toString();
    hora = json['hora'].toString();
    fechaFin = json['fechaFin'].toString();
    horaFin = json['horaFin'].toString();
    titulo = json['titulo'].toString();
    lugar = json['lugar'].toString();
    direccion = json['direccion'].toString();
    descripcionCorta = json['descripcionCorta'].toString();
    descripcion = json['descripcion'].toString();
    seats = json['seats'].toString();
    tipo = json['tipo'].toString();
    etiqueta = json['etiqueta'].toString();
    imagen = json['imagen'].toString();
    portada = json['portada'].toString();
    distrito = json['distrito'].toString();
    region = json['region'].toString();
    activo = json['activo'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idEvento'] = this.idEvento;
    data['idOrganizacion'] = this.idOrganizacion;
    data['idIglesia'] = this.idIglesia;
    data['fecha'] = this.fecha;
    data['hora'] = this.hora;
    data['fechaFin'] = this.fechaFin;
    data['horaFin'] = this.horaFin;
    data['titulo'] = this.titulo;
    data['lugar'] = this.lugar;
    data['direccion'] = this.direccion;
    data['descripcionCorta'] = this.descripcionCorta;
    data['descripcion'] = this.descripcion;
    data['seats'] = this.seats;
    data['tipo'] = this.tipo;
    data['etiqueta'] = this.etiqueta;
    data['imagen'] = this.imagen;
    data['portada'] = this.portada;
    data['distrito'] = this.distrito;
    data['region'] = this.region;
    data['activo'] = this.activo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
