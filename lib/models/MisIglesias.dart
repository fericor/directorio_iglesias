class MisIglesia {
  final String? idIglesia;
  final String? idUsuario;
  final String? idPastor;
  final String? idOrganizacion;
  final String? titulo;
  final String? direccion;
  final String? comunidad;
  final String? provincia;
  final String? ciudad;
  final String? distrito;
  final String? region;
  final String? zona;
  final String? descripcion;
  final String? valoracion;
  final String? latitud;
  final String? longitud;
  final String? telefono;
  final String? email;
  final String? web;
  final String? ranking;
  final String? asistentes;
  final String? servicios;
  final String? horario;
  final String? activo;
  final String? createdAt;
  final String? updatedAt;

  MisIglesia({
    this.idIglesia,
    this.idUsuario,
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
  });

  factory MisIglesia.fromJson(Map<String, dynamic> json) {
    return MisIglesia(
      idIglesia: json['idIglesia']?.toString(),
      idUsuario: json['idUsuario']?.toString(),
      idPastor: json['idPastor']?.toString(),
      idOrganizacion: json['idOrganizacion']?.toString(),
      titulo: json['titulo']?.toString(),
      direccion: json['direccion']?.toString(),
      comunidad: json['comunidad']?.toString(),
      provincia: json['provincia']?.toString(),
      ciudad: json['ciudad']?.toString(),
      distrito: json['distrito']?.toString(),
      region: json['region']?.toString(),
      zona: json['zona']?.toString(),
      descripcion: json['descripcion']?.toString(),
      valoracion: json['valoracion']?.toString(),
      latitud: json['latitud']?.toString(),
      longitud: json['longitud']?.toString(),
      telefono: json['telefono']?.toString(),
      email: json['email']?.toString(),
      web: json['web']?.toString(),
      ranking: json['ranking']?.toString(),
      asistentes: json['asistentes']?.toString(),
      servicios: json['servicios']?.toString(),
      horario: json['horario']?.toString(),
      activo: json['activo']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idIglesia != null) 'idIglesia': idIglesia,
      'idPastor': idPastor,
      'idUsuario': idUsuario,
      'idOrganizacion': idOrganizacion,
      'titulo': titulo,
      'direccion': direccion,
      'comunidad': comunidad,
      'provincia': provincia,
      'ciudad': ciudad,
      'distrito': distrito,
      'region': region,
      'zona': zona,
      'descripcion': descripcion,
      'valoracion': valoracion,
      'latitud': latitud,
      'longitud': longitud,
      'telefono': telefono,
      'email': email,
      'web': web,
      'ranking': ranking,
      'asistentes': asistentes,
      'servicios': servicios,
      'horario': horario,
      'activo': activo,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  MisIglesia copyWith({
    String? idIglesia,
    String? idUsuario,
    String? idPastor,
    String? idOrganizacion,
    String? titulo,
    String? direccion,
    String? comunidad,
    String? provincia,
    String? ciudad,
    String? distrito,
    String? region,
    String? zona,
    String? descripcion,
    String? valoracion,
    String? latitud,
    String? longitud,
    String? telefono,
    String? email,
    String? web,
    String? ranking,
    String? asistentes,
    String? servicios,
    String? horario,
    String? activo,
    String? createdAt,
    String? updatedAt,
  }) {
    return MisIglesia(
      idIglesia: idIglesia ?? this.idIglesia,
      idUsuario: idUsuario ?? this.idUsuario,
      idPastor: idPastor ?? this.idPastor,
      idOrganizacion: idOrganizacion ?? this.idOrganizacion,
      titulo: titulo ?? this.titulo,
      direccion: direccion ?? this.direccion,
      comunidad: comunidad ?? this.comunidad,
      provincia: provincia ?? this.provincia,
      ciudad: ciudad ?? this.ciudad,
      distrito: distrito ?? this.distrito,
      region: region ?? this.region,
      zona: zona ?? this.zona,
      descripcion: descripcion ?? this.descripcion,
      valoracion: valoracion ?? this.valoracion,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      web: web ?? this.web,
      ranking: ranking ?? this.ranking,
      asistentes: asistentes ?? this.asistentes,
      servicios: servicios ?? this.servicios,
      horario: horario ?? this.horario,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
