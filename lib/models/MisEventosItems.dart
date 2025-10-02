// Modelo para la respuesta completa de la API
class EventoItemsResponse {
  final List<MisEventoItem> itemsDisponibles;
  final String evento;

  EventoItemsResponse({
    required this.itemsDisponibles,
    required this.evento,
  });

  factory EventoItemsResponse.fromJson(Map<String, dynamic> json) {
    return EventoItemsResponse(
      itemsDisponibles: (json['items_disponibles'] as List<dynamic>)
          .map((item) => MisEventoItem.fromJson(item))
          .toList(),
      evento: json['evento'] ?? '',
    );
  }
}

// Modelo para cada item del evento
class MisEventoItem {
  final String? id;
  final String idEvento;
  final String titulo;
  final String descripcion;
  final double precio;
  final int cantidad;
  final int disponible;
  final int reservadas;

  MisEventoItem({
    this.id,
    required this.idEvento,
    required this.titulo,
    required this.descripcion,
    required this.precio,
    required this.cantidad,
    required this.disponible,
    required this.reservadas,
  });

  factory MisEventoItem.fromJson(Map<String, dynamic> json) {
    return MisEventoItem(
      id: json['id']?.toString(),
      idEvento: json['idEvento']?.toString() ?? '',
      titulo: json['titulo']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      precio: double.tryParse(json['precio']?.toString() ?? '0') ?? 0.0,
      cantidad: int.tryParse(json['cantidad']?.toString() ?? '0') ?? 0,
      disponible: int.tryParse(json['disponible']?.toString() ?? '0') ?? 0,
      reservadas: int.tryParse(json['reservadas']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'idEvento': idEvento,
      'titulo': titulo,
      'descripcion': descripcion,
      'precio': precio.toString(),
      'cantidad': cantidad.toString(),
    };
  }
}
