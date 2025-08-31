class MisReservas {
  int? idReserva;
  int? idEvento;
  int? idUsuario;
  Null? idAsiento;
  String? codigoReserva;
  String? estado;
  String? fechaReserva;
  String? createdAt;
  String? updatedAt;
  String? montoTotal;
  List<Miseventos>? miseventos;

  MisReservas(
      {this.idReserva,
      this.idEvento,
      this.idUsuario,
      this.idAsiento,
      this.codigoReserva,
      this.estado,
      this.fechaReserva,
      this.createdAt,
      this.updatedAt,
      this.montoTotal,
      this.miseventos});

  MisReservas.fromJson(Map<String, dynamic> json) {
    idReserva = json['idReserva'];
    idEvento = json['idEvento'];
    idUsuario = json['idUsuario'];
    idAsiento = json['idAsiento'];
    codigoReserva = json['codigo_reserva'];
    estado = json['estado'];
    fechaReserva = json['fecha_reserva'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    montoTotal = json['monto_total'];
    if (json['miseventos'] != null) {
      miseventos = <Miseventos>[];
      json['miseventos'].forEach((v) {
        miseventos!.add(new Miseventos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idReserva'] = this.idReserva;
    data['idEvento'] = this.idEvento;
    data['idUsuario'] = this.idUsuario;
    data['idAsiento'] = this.idAsiento;
    data['codigo_reserva'] = this.codigoReserva;
    data['estado'] = this.estado;
    data['fecha_reserva'] = this.fechaReserva;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['monto_total'] = this.montoTotal;
    if (this.miseventos != null) {
      data['miseventos'] = this.miseventos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Miseventos {
  int? idEvento;
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
  int? portada;
  String? distrito;
  int? region;
  int? activo;
  int? esGratis;
  String? createdAt;
  String? updatedAt;

  Miseventos(
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
      this.esGratis,
      this.createdAt,
      this.updatedAt});

  Miseventos.fromJson(Map<String, dynamic> json) {
    idEvento = json['idEvento'];
    idOrganizacion = json['idOrganizacion'].toString();
    idIglesia = json['idIglesia'].toString();
    fecha = json['fecha'];
    hora = json['hora'];
    fechaFin = json['fechaFin'];
    horaFin = json['horaFin'];
    titulo = json['titulo'];
    lugar = json['lugar'];
    direccion = json['direccion'];
    descripcionCorta = json['descripcionCorta'];
    descripcion = json['descripcion'];
    seats = json['seats'];
    tipo = json['tipo'];
    etiqueta = json['etiqueta'];
    imagen = json['imagen'];
    portada = json['portada'];
    distrito = json['distrito'];
    region = json['region'];
    activo = json['activo'];
    esGratis = json['esGratis'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['esGratis'] = this.esGratis;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
