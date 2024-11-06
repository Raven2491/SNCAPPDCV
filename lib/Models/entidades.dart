class Entidad {
  final String imagen;
  final String? logo;
  final String razonsocial;
  final String ruc;
  final String categoria;
  final String direccion;
  final String? departamento;
  final String? provincia;
  final String? distrito;
  final String latitud;
  final String longitud;
  final String estado;
  final String precio;
  final String descripcion;
  final String calificacion;
  double? proximidad;

  Entidad(
      {required this.imagen,
      this.logo,
      required this.razonsocial,
      required this.ruc,
      required this.categoria,
      required this.direccion,
      this.departamento,
      this.provincia,
      this.distrito,
      required this.latitud,
      required this.longitud,
      required this.estado,
      required this.precio,
      required this.descripcion,
      required this.calificacion,
      this.proximidad});

  factory Entidad.fromJson(Map<String, dynamic> json) {
    return Entidad(
        distrito: json['distrito'],
        ruc: json['ruc'],
        razonsocial: json['razonsocial'],
        direccion: json['direccion'],
        departamento: json['departamento'],
        provincia: json['provincia'],
        estado: json['estado'],
        latitud: json['latitud'],
        longitud: json['longitud'],
        calificacion: json['calificacion'],
        categoria: json['categoria'],
        descripcion: json['descripcion'],
        precio: json['precio'] ?? '',
        imagen: json['imagen'] ?? '');
  }
}
