class Iglesia {
  final int idIglesia;
  final String titulo;
  final String direccion;
  final String ciudad;

  Iglesia({
    required this.idIglesia,
    required this.titulo,
    required this.direccion,
    required this.ciudad,
  });

  factory Iglesia.fromJson(Map<String, dynamic> json) {
    return Iglesia(
      idIglesia: json['idIglesia'] ?? 0,
      titulo: json['titulo'] ?? '',
      direccion: json['direccion'] ?? '',
      ciudad: json['ciudad'] ?? '',
    );
  }

  @override
  String toString() => titulo;
}
