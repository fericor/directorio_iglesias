class EventosItems {
  List<Evento>? evento;
  List<Items>? items;

  EventosItems({this.evento, this.items});

  EventosItems.fromJson(Map<String, dynamic> json) {
    if (json['evento'] != null) {
      evento = <Evento>[];
      json['evento'].forEach((v) {
        evento!.add(Evento.fromJson(v));
      });
    }
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (evento != null) {
      data['evento'] = evento!.map((v) => v.toJson()).toList();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
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
  String? descripcionCorta;
  String? descripcion;
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
      this.descripcionCorta,
      this.descripcion,
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
    descripcionCorta = json['descripcionCorta'];
    descripcion = json['descripcion'];
    tipo = json['tipo'];
    etiqueta = json['etiqueta'];
    imagen = json['imagen'];
    portada = json['portada'].toString();
    distrito = json['distrito'];
    region = json['region'].toString();
    activo = json['activo'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idEvento'] = idEvento;
    data['fecha'] = fecha;
    data['hora'] = hora;
    data['fechaFin'] = fechaFin;
    data['horaFin'] = horaFin;
    data['titulo'] = titulo;
    data['descripcionCorta'] = descripcionCorta;
    data['descripcion'] = descripcion;
    data['tipo'] = tipo;
    data['etiqueta'] = etiqueta;
    data['imagen'] = imagen;
    data['portada'] = portada;
    data['distrito'] = distrito;
    data['region'] = region;
    data['activo'] = activo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
    titulo = json['titulo'];
    descripcion = json['descripcion'];
    precio = json['precio'];
    cantidad = json['cantidad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['idEvento'] = idEvento;
    data['titulo'] = titulo;
    data['descripcion'] = descripcion;
    data['precio'] = precio;
    data['cantidad'] = cantidad;
    return data;
  }
}
