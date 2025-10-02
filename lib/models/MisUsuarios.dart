class MisUsuario {
  int? id;
  int? idPais;
  int? idOrganizacion;
  int? idIglesia;
  String? apiToken;
  String? nombre;
  String? apellidos;
  String? nacimiento;
  String? telefono;
  String? email;
  String? password;
  String? role;
  String? genero;
  String? ipConexion;
  String? tokenNotificacion;
  String? tokenActivation;
  int? aceptadaPoliticaPrivacidad;
  int? aceptadaComunicados;
  int? activo;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  MisUsuario({
    this.id,
    this.idPais,
    this.idOrganizacion,
    this.idIglesia,
    this.apiToken,
    this.nombre,
    this.apellidos,
    this.nacimiento,
    this.telefono,
    this.email,
    this.password,
    this.role,
    this.genero,
    this.ipConexion,
    this.tokenNotificacion,
    this.tokenActivation,
    this.aceptadaPoliticaPrivacidad,
    this.aceptadaComunicados,
    this.activo,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory MisUsuario.fromJson(Map<String, dynamic> json) => MisUsuario(
        id: json['id'],
        idPais: json['idPais'],
        idOrganizacion: json['idOrganizacion'],
        idIglesia: json['idIglesia'],
        apiToken: json['api_token'] ?? '',
        nombre: json['nombre'] ?? '',
        apellidos: json['apellidos'] ?? '',
        nacimiento: json['nacimiento'],
        telefono: json['telefono'] ?? '',
        email: json['email'] ?? '',
        password: json['password'] ?? '',
        role: json['role'].toString() ?? '',
        genero: json['genero'] ?? '',
        ipConexion: json['ipConexion'] ?? '',
        tokenNotificacion: json['tokenNotificacion'] ?? '',
        tokenActivation: json['tokenActivation'] ?? '',
        aceptadaPoliticaPrivacidad: json['aceptadaPoliticaPrivacidad'],
        aceptadaComunicados: json['aceptadaComunicados'],
        activo: json['activo'],
        emailVerifiedAt: json['email_verified_at'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idPais": idPais,
        "idOrganizacion": idOrganizacion,
        "idIglesia": idIglesia,
        "api_token": apiToken,
        "nombre": nombre,
        "apellidos": apellidos,
        "nacimiento": nacimiento,
        "telefono": telefono,
        "email": email,
        "password": password,
        "role": role,
        "genero": genero,
        "ipConexion": ipConexion,
        "tokenNotificacion": tokenNotificacion,
        "tokenActivation": tokenActivation,
        "aceptadaPoliticaPrivacidad": aceptadaPoliticaPrivacidad,
        "aceptadaComunicados": aceptadaComunicados,
        "activo": activo,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
