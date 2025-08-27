class Categorias {
  int? id;
  int? idOrganizacion;
  String? titulo;
  String? descripcion;
  int? activo;

  Categorias(
      {this.id,
      this.idOrganizacion,
      this.titulo,
      this.descripcion,
      this.activo});

  Categorias.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idOrganizacion = json['idOrganizacion'];
    titulo = json['titulo'];
    descripcion = json['descripcion'];
    activo = json['activo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idOrganizacion'] = this.idOrganizacion;
    data['titulo'] = this.titulo;
    data['descripcion'] = this.descripcion;
    data['activo'] = this.activo;
    return data;
  }
}
