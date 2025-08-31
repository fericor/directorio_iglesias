class Iglesias {
  int? idIglesia;
  int? idPastor;
  int? idOrganizacion;
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
  String? email;
  String? web;
  String? ranking;
  String? asistentes;
  String? servicios;
  String? horario;
  int? activo;
  String? createdAt;
  String? updatedAt;
  List<EventosIglesia>? eventosIglesia;
  List<PastoresIglesia>? pastoresIglesia;
  List<ImagenesIglesia>? imagenesIglesia;

  Iglesias(
      {this.idIglesia,
      this.idPastor,
      this.idOrganizacion,
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
      this.email,
      this.web,
      this.ranking,
      this.asistentes,
      this.servicios,
      this.horario,
      this.activo,
      this.createdAt,
      this.updatedAt,
      this.eventosIglesia,
      this.pastoresIglesia,
      this.imagenesIglesia});

  Iglesias.fromJson(Map<String, dynamic> json) {
    idIglesia = json['idIglesia'];
    idPastor = json['idPastor'];
    idOrganizacion = json['idOrganizacion'];
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
    email = json['email'].toString() ?? "";
    web = json['web'].toString() ?? "";
    ranking = json['ranking'].toString() ?? "";
    asistentes = json['asistentes'].toString() ?? "";
    servicios = json['servicios'].toString() ?? "";
    horario = json['horario'].toString() ?? "";
    activo = json['activo'];
    createdAt = json['created_at'].toString() ?? "";
    updatedAt = json['updated_at'];
    if (json['eventosIglesia'] != null) {
      eventosIglesia = <EventosIglesia>[];
      json['eventosIglesia'].forEach((v) {
        eventosIglesia!.add(new EventosIglesia.fromJson(v));
      });
    }
    if (json['pastoresIglesia'] != null) {
      pastoresIglesia = <PastoresIglesia>[];
      json['pastoresIglesia'].forEach((v) {
        pastoresIglesia!.add(new PastoresIglesia.fromJson(v));
      });
    }
    if (json['imagenesIglesia'] != null) {
      imagenesIglesia = <ImagenesIglesia>[];
      json['imagenesIglesia'].forEach((v) {
        imagenesIglesia!.add(new ImagenesIglesia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idIglesia'] = this.idIglesia;
    data['idPastor'] = this.idPastor;
    data['idOrganizacion'] = this.idOrganizacion;
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
    data['email'] = this.email;
    data['web'] = this.web;
    data['ranking'] = this.ranking;
    data['asistentes'] = this.asistentes;
    data['servicios'] = this.servicios;
    data['horario'] = this.horario;
    data['activo'] = this.activo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.eventosIglesia != null) {
      data['eventosIglesia'] =
          this.eventosIglesia!.map((v) => v.toJson()).toList();
    }
    if (this.pastoresIglesia != null) {
      data['pastoresIglesia'] =
          this.pastoresIglesia!.map((v) => v.toJson()).toList();
    }
    if (this.imagenesIglesia != null) {
      data['imagenesIglesia'] =
          this.imagenesIglesia!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventosIglesia {
  int? idEvento;
  int? idOrganizacion;
  int? idIglesia;
  String? fecha;
  String? hora;
  String? fechaFin;
  String? horaFin;
  String? titulo;
  String? lugar;
  String? direccion;
  String? descripcionCorta;
  String? descripcion;
  String? infoExtra;
  String? seats;
  String? tipo;
  String? etiqueta;
  String? imagen;
  String? portada;
  String? distrito;
  String? region;
  String? esGratis;
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
      this.infoExtra,
      this.seats,
      this.tipo,
      this.etiqueta,
      this.imagen,
      this.portada,
      this.distrito,
      this.region,
      this.esGratis,
      this.activo,
      this.createdAt,
      this.updatedAt});

  EventosIglesia.fromJson(Map<String, dynamic> json) {
    idEvento = json['idEvento'];
    idOrganizacion = json['idOrganizacion'];
    idIglesia = json['idIglesia'];
    fecha = json['fecha'];
    hora = json['hora'];
    fechaFin = json['fechaFin'];
    horaFin = json['horaFin'];
    titulo = json['titulo'];
    lugar = json['lugar'];
    direccion = json['direccion'];
    descripcionCorta = json['descripcionCorta'];
    descripcion = json['descripcion'];
    infoExtra = json['infoExtra'];
    seats = json['seats'];
    tipo = json['tipo'];
    etiqueta = json['etiqueta'];
    imagen = json['imagen'];
    portada = json['portada'].toString();
    distrito = json['distrito'].toString();
    region = json['region'].toString();
    esGratis = json['esGratis'].toString();
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
    data['infoExtra'] = this.infoExtra;
    data['seats'] = this.seats;
    data['tipo'] = this.tipo;
    data['etiqueta'] = this.etiqueta;
    data['imagen'] = this.imagen;
    data['portada'] = this.portada;
    data['distrito'] = this.distrito;
    data['region'] = this.region;
    data['esGratis'] = this.esGratis;
    data['activo'] = this.activo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class PastoresIglesia {
  int? idPastor;
  int? idOrganizacion;
  int? idIglesia;
  String? nombre;
  String? apellidos;
  String? telefonoFijo;
  String? telefonoMovil;
  String? email;
  String? imagen;
  String? detalles;
  int? valoraciones;
  String? insignias;
  String? socialMedia;
  String? experiencia;
  String? especialidad;
  String? createdAt;
  String? updatedAt;

  PastoresIglesia(
      {this.idPastor,
      this.idOrganizacion,
      this.idIglesia,
      this.nombre,
      this.apellidos,
      this.telefonoFijo,
      this.telefonoMovil,
      this.email,
      this.imagen,
      this.detalles,
      this.valoraciones,
      this.insignias,
      this.socialMedia,
      this.experiencia,
      this.especialidad,
      this.createdAt,
      this.updatedAt});

  PastoresIglesia.fromJson(Map<String, dynamic> json) {
    idPastor = json['idPastor'];
    idOrganizacion = json['idOrganizacion'];
    idIglesia = json['idIglesia'];
    nombre = json['nombre'];
    apellidos = json['apellidos'];
    telefonoFijo = json['telefono_fijo'];
    telefonoMovil = json['telefono_movil'];
    email = json['email'];
    imagen = json['imagen'];
    detalles = json['detalles'];
    valoraciones = json['valoraciones'];
    insignias = json['insignias'];
    socialMedia = json['socialMedia'];
    experiencia = json['experiencia'];
    especialidad = json['especialidad'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idPastor'] = this.idPastor;
    data['idOrganizacion'] = this.idOrganizacion;
    data['idIglesia'] = this.idIglesia;
    data['nombre'] = this.nombre;
    data['apellidos'] = this.apellidos;
    data['telefono_fijo'] = this.telefonoFijo;
    data['telefono_movil'] = this.telefonoMovil;
    data['email'] = this.email;
    data['imagen'] = this.imagen;
    data['detalles'] = this.detalles;
    data['valoraciones'] = this.valoraciones;
    data['insignias'] = this.insignias;
    data['socialMedia'] = this.socialMedia;
    data['experiencia'] = this.experiencia;
    data['especialidad'] = this.especialidad;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ImagenesIglesia {
  int? idImagen;
  int? idOrganizacion;
  int? idIglesia;
  String? imagen;
  int? activo;

  ImagenesIglesia(
      {this.idImagen,
      this.idOrganizacion,
      this.idIglesia,
      this.imagen,
      this.activo});

  ImagenesIglesia.fromJson(Map<String, dynamic> json) {
    idImagen = json['idImagen'];
    idOrganizacion = json['idOrganizacion'];
    idIglesia = json['idIglesia'];
    imagen = json['imagen'];
    activo = json['activo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idImagen'] = this.idImagen;
    data['idOrganizacion'] = this.idOrganizacion;
    data['idIglesia'] = this.idIglesia;
    data['imagen'] = this.imagen;
    data['activo'] = this.activo;
    return data;
  }
}
