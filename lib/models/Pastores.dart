class Pastores {
  int? idPastor;
  int? idOrganizacion;
  int? idIglesia;
  String? nombre;
  String? apellidos;
  String? telefonoFijo;
  String? telefonoMovil;
  String? email;
  String? imagen;
  String? detalles;
  int? valoraciones;
  String? insignias;
  String? socialMedia;

  Pastores(
      {this.idPastor,
      this.idOrganizacion,
      this.idIglesia,
      this.nombre,
      this.apellidos,
      this.telefonoFijo,
      this.telefonoMovil,
      this.email,
      this.imagen,
      this.detalles,
      this.valoraciones,
      this.insignias,
      this.socialMedia});

  Pastores.fromJson(Map<String, dynamic> json) {
    idPastor = json['idPastor'];
    idOrganizacion = json['idOrganizacion'];
    idIglesia = json['idIglesia'];
    nombre = json['nombre'];
    apellidos = json['apellidos'];
    telefonoFijo = json['telefono_fijo'];
    telefonoMovil = json['telefono_movil'];
    email = json['email'];
    imagen = json['imagen'];
    detalles = json['detalles'];
    valoraciones = json['valoraciones'];
    insignias = json['insignias'];
    socialMedia = json['socialMedia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idPastor'] = this.idPastor;
    data['idOrganizacion'] = this.idOrganizacion;
    data['idIglesia'] = this.idIglesia;
    data['nombre'] = this.nombre;
    data['apellidos'] = this.apellidos;
    data['telefono_fijo'] = this.telefonoFijo;
    data['telefono_movil'] = this.telefonoMovil;
    data['email'] = this.email;
    data['imagen'] = this.imagen;
    data['detalles'] = this.detalles;
    data['valoraciones'] = this.valoraciones;
    data['insignias'] = this.insignias;
    data['socialMedia'] = this.socialMedia;
    return data;
  }
}
