class Reserva {
  final String idReserva;
  final String idEvento;
  final String idUsuario;
  final String? idAsiento;
  final String codigoReserva;
  final String estado;
  final double montoTotal;
  final DateTime fechaReserva;
  final Evento? evento;
  final Asiento? asiento;
  final List<ReservaItem> items;

  Reserva({
    required this.idReserva,
    required this.idEvento,
    required this.idUsuario,
    this.idAsiento,
    required this.codigoReserva,
    required this.estado,
    required this.montoTotal,
    required this.fechaReserva,
    this.evento,
    this.asiento,
    required this.items,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      idReserva: json['idReserva'].toString() ?? "0",
      idEvento: json['idEvento'].toString() ?? "0",
      idUsuario: json['idUsuario'].toString() ?? "0",
      idAsiento: json['idAsiento'].toString() ?? "0",
      codigoReserva: json['codigo_reserva'] ?? '',
      estado: json['estado'] ?? '',
      montoTotal: double.parse((json['monto_total'] ?? "0").toString()),
      fechaReserva:
          DateTime.parse(json['fecha_reserva'] ?? DateTime.now().toString()),
      evento: json['evento'] != null ? Evento.fromJson(json['evento']) : null,
      asiento:
          json['asiento'] != null ? Asiento.fromJson(json['asiento']) : null,
      items: (json['items'] as List? ?? [])
          .map((item) => ReservaItem.fromJson(item))
          .toList(),
    );
  }
}

class ReservaItem {
  final String id;
  final String idReserva;
  final String idEventoItem;
  final String cantidad;
  final double precioUnitario;
  final double subtotal;
  final EventoItem? eventoItem;

  ReservaItem({
    required this.id,
    required this.idReserva,
    required this.idEventoItem,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    this.eventoItem,
  });

  factory ReservaItem.fromJson(Map<String, dynamic> json) {
    return ReservaItem(
      id: json['id'].toString() ?? "0",
      idReserva: json['idReserva'].toString() ?? "0",
      idEventoItem: json['idEventoItem'].toString() ?? "0",
      cantidad: json['cantidad'].toString() ?? "0",
      precioUnitario: double.parse((json['precio_unitario'] ?? "0").toString()),
      subtotal: double.parse((json['subtotal'] ?? "0").toString()),
      eventoItem: json['eventoItem'] != null
          ? EventoItem.fromJson(json['eventoItem'])
          : null,
    );
  }
}

class EventoItem {
  final String id;
  final String idEvento;
  final String titulo;
  final String descripcion;
  final double precio;
  final String cantidad;
  final String? disponible;
  final String? reservadas;

  EventoItem({
    required this.id,
    required this.idEvento,
    required this.titulo,
    required this.descripcion,
    required this.precio,
    required this.cantidad,
    this.disponible,
    this.reservadas,
  });

  factory EventoItem.fromJson(Map<String, dynamic> json) {
    return EventoItem(
      id: json['id'] ?? "0",
      idEvento: json['idEvento'] ?? "0",
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      precio: double.parse((json['precio'] ?? "0").toString()),
      cantidad: json['cantidad'] ?? "0",
      disponible: json['disponible'],
      reservadas: json['reservadas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idEvento': idEvento,
      'titulo': titulo,
      'descripcion': descripcion,
      'precio': precio,
      'cantidad': cantidad,
    };
  }
}

class Evento {
  final String idEvento;
  final String titulo;
  final bool tieneAsientos;
  final bool activo;

  Evento({
    required this.idEvento,
    required this.titulo,
    required this.tieneAsientos,
    required this.activo,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      idEvento: json['idEvento'].toString() ?? "0",
      titulo: json['titulo'] ?? '',
      tieneAsientos: json['seats'] == 1 || json['seats'] == true,
      activo: json['activo'] == 1 || json['activo'] == true,
    );
  }
}

class Asiento {
  final String id;
  final String idEvento;
  final String fila;
  final String columna;
  final double valor;
  final String estado;

  Asiento({
    required this.id,
    required this.idEvento,
    required this.fila,
    required this.columna,
    required this.valor,
    required this.estado,
  });

  factory Asiento.fromJson(Map<String, dynamic> json) {
    return Asiento(
      id: json['id'].toString() ?? "0",
      idEvento: json['idEvento'].toString() ?? "0",
      fila: json['fila'].toString() ?? '',
      columna: json['columna'].toString() ?? '',
      valor: double.parse((json['valor'] ?? "0").toString()),
      estado: json['estado'].toString() ?? '',
    );
  }
}

class DisponibilidadEvento {
  final String evento;
  final bool tieneAsientos;
  final String disponible;
  final String capacidadTotal;
  final String reservado;

  DisponibilidadEvento({
    required this.evento,
    required this.tieneAsientos,
    required this.disponible,
    required this.capacidadTotal,
    required this.reservado,
  });

  factory DisponibilidadEvento.fromJson(Map<String, dynamic> json) {
    return DisponibilidadEvento(
      evento: json['evento'] ?? '',
      tieneAsientos: json['tiene_asientos'] ?? false,
      disponible: json['disponible'] ?? "0",
      capacidadTotal: json['capacidad_total'] ?? "0",
      reservado: json['reservado'] ?? "0",
    );
  }
}
