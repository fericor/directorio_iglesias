class EventosItems {
  List<Evento>? evento;
  List<Items>? items;
  List<Reservas>? reservas;

  EventosItems({this.evento, this.items, this.reservas});

  EventosItems.fromJson(Map<String, dynamic> json) {
    if (json['evento'] != null) {
      evento = <Evento>[];
      json['evento'].forEach((v) {
        evento!.add(new Evento.fromJson(v));
      });
    }
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
    if (this.evento != null) {
      data['evento'] = this.evento!.map((v) => v.toJson()).toList();
    }
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.reservas != null) {
      data['reservas'] = this.reservas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Evento {
  String? idEvento;
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

  Evento(
      {this.idEvento,
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

  Evento.fromJson(Map<String, dynamic> json) {
    idEvento = json['idEvento'].toString();
    fecha = json['fecha'];
    hora = json['hora'];
    fechaFin = json['fechaFin'];
    horaFin = json['horaFin'];
    titulo = json['titulo'];
    lugar = json['lugar'];
    direccion = json['direccion'];
    descripcionCorta = json['descripcionCorta'];
    descripcion = json['descripcion'];
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

class Items {
  String? id;
  String? idEvento;
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
    id = json['id'].toString();
    idEvento = json['idEvento'].toString();
    titulo = json['titulo'].toString();
    descripcion = json['descripcion'].toString();
    precio = json['precio'].toString();
    cantidad = json['cantidad'].toString();
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
  String? idReserva;
  String? idEvento;
  String? idUsuario;
  String? idAsiento;
  String? codigoReserva;
  String? estado;
  String? fechaReserva;
  String? createdAt;
  String? updatedAt;
  String? montoTotal;
  List<Entradas>? entradas;

  Reservas(
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
      this.entradas});

  Reservas.fromJson(Map<String, dynamic> json) {
    idReserva = json['idReserva'].toString();
    idEvento = json['idEvento'].toString();
    idUsuario = json['idUsuario'].toString();
    idAsiento = json['idAsiento'].toString();
    codigoReserva = json['codigo_reserva'].toString();
    estado = json['estado'].toString();
    fechaReserva = json['fecha_reserva'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    montoTotal = json['monto_total'];
    if (json['entradas'] != null) {
      entradas = <Entradas>[];
      json['entradas'].forEach((v) {
        entradas!.add(new Entradas.fromJson(v));
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
    if (this.entradas != null) {
      data['entradas'] = this.entradas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Entradas {
  String? id;
  String? idReserva;
  String? idEventoItem;
  String? cantidad;
  String? precioUnitario;
  String? subtotal;
  String? tituloEventoItem;
  String? createdAt;
  String? updatedAt;

  Entradas(
      {this.id,
      this.idReserva,
      this.idEventoItem,
      this.cantidad,
      this.precioUnitario,
      this.subtotal,
      this.tituloEventoItem,
      this.createdAt,
      this.updatedAt});

  Entradas.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    idReserva = json['idReserva'].toString();
    idEventoItem = json['idEventoItem'].toString();
    cantidad = json['cantidad'].toString();
    precioUnitario = json['precio_unitario'].toString();
    subtotal = json['subtotal'].toString();
    tituloEventoItem = json['tituloEventoItem'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idReserva'] = this.idReserva;
    data['idEventoItem'] = this.idEventoItem;
    data['cantidad'] = this.cantidad;
    data['precio_unitario'] = this.precioUnitario;
    data['subtotal'] = this.subtotal;
    data['tituloEventoItem'] = this.tituloEventoItem;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
