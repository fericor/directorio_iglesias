class Categorias {
  int? id;
  int? idOrganizacion;
  int? idIglesia;
  String? titulo;
  String? descripcion;
  int? activo;

  Categorias(
      {this.id,
      this.idOrganizacion,
      this.idIglesia,
      this.titulo,
      this.descripcion,
      this.activo});

  Categorias.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idOrganizacion = json['idOrganizacion'];
    idIglesia = json['idIglesia'];
    titulo = json['titulo'];
    descripcion = json['descripcion'];
    activo = json['activo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idOrganizacion'] = this.idOrganizacion;
    data['idIglesia'] = this.idIglesia;
    data['titulo'] = this.titulo;
    data['descripcion'] = this.descripcion;
    data['activo'] = this.activo;
    return data;
  }
}
