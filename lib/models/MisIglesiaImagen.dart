class IglesiaImagen {
  int? idImagen;
  int? idOrganizacion;
  int? idIglesia;
  String? imagen;
  int? activo;

  IglesiaImagen(
      {this.idImagen,
      this.idOrganizacion,
      this.idIglesia,
      this.imagen,
      this.activo});

  IglesiaImagen.fromJson(Map<String, dynamic> json) {
    idImagen = json['idImagen'];
    idOrganizacion = json['idOrganizacion'];
    idIglesia = json['idIglesia'];
    imagen = json['imagen'];
    activo = json['activo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idImagen'] = this.idImagen;
    data['idOrganizacion'] = this.idOrganizacion;
    data['idIglesia'] = this.idIglesia;
    data['imagen'] = this.imagen;
    data['activo'] = this.activo;
    return data;
  }
}
