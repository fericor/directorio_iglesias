class MisEventos {
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
  int? portada;
  String? distrito;
  String? region;
  int? esGratis;
  int? activo;
  String? createdAt;
  String? updatedAt;
  List<Items>? items;
  List<Reservas>? reservas;

  MisEventos(
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
      this.updatedAt,
      this.items,
      this.reservas});

  MisEventos.fromJson(Map<String, dynamic> json) {
    idEvento = json['idEvento'];
    idOrganizacion = json['idOrganizacion'] ?? 0;
    idIglesia = json['idIglesia'] ?? 0;
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
    portada = json['portada'];
    distrito = json['distrito'].toString();
    region = json['region'].toString();
    esGratis = json['esGratis'];
    activo = json['activo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    if (json['reservas'] != null) {
      reservas = <Reservas>[];
      json['reservas'].forEach((v) {
        reservas!.add(new Reservas.fromJson(v));
      });
    }
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
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.reservas != null) {
      data['reservas'] = this.reservas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  int? idEvento;
  String? titulo;
  String? descripcion;
  String? precio;
  String? cantidad;

  Items(
      {this.id,
      this.idEvento,
      this.titulo,
      this.descripcion,
      this.precio,
      this.cantidad});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idEvento = json['idEvento'];
    titulo = json['titulo'];
    descripcion = json['descripcion'];
    precio = json['precio'];
    cantidad = json['cantidad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idEvento'] = this.idEvento;
    data['titulo'] = this.titulo;
    data['descripcion'] = this.descripcion;
    data['precio'] = this.precio;
    data['cantidad'] = this.cantidad;
    return data;
  }
}

class Reservas {
  int? idReserva;
  int? idEvento;
  int? idIglesia;
  int? idUsuario;
  Null? idAsiento;
  String? codigoReserva;
  String? estado;
  String? fechaReserva;
  String? createdAt;
  String? updatedAt;
  String? montoTotal;

  Reservas(
      {this.idReserva,
      this.idEvento,
      this.idIglesia,
      this.idUsuario,
      this.idAsiento,
      this.codigoReserva,
      this.estado,
      this.fechaReserva,
      this.createdAt,
      this.updatedAt,
      this.montoTotal});

  Reservas.fromJson(Map<String, dynamic> json) {
    idReserva = json['idReserva'];
    idEvento = json['idEvento'];
    idIglesia = json['idIglesia'];
    idUsuario = json['idUsuario'];
    idAsiento = json['idAsiento'];
    codigoReserva = json['codigo_reserva'];
    estado = json['estado'];
    fechaReserva = json['fecha_reserva'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    montoTotal = json['monto_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idReserva'] = this.idReserva;
    data['idEvento'] = this.idEvento;
    data['idIglesia'] = this.idIglesia;
    data['idUsuario'] = this.idUsuario;
    data['idAsiento'] = this.idAsiento;
    data['codigo_reserva'] = this.codigoReserva;
    data['estado'] = this.estado;
    data['fecha_reserva'] = this.fechaReserva;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['monto_total'] = this.montoTotal;
    return data;
  }
}
