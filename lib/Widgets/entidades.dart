class Entidad {
  final String? distrito;
  final String ruc;
  final String razonsocial;
  final String direccion;
  final String? departamento;
  final String? provincia;
  final String estado;
  final String latitud;
  final String longitud;
  final String calificacion;
  final String categoria;
  final String descripcion;
  final String precio;
  final String imagen;
  double? proximidad;

  Entidad(
      {this.distrito,
      required this.ruc,
      required this.razonsocial,
      required this.direccion,
      this.departamento,
      this.provincia,
      required this.estado,
      required this.latitud,
      required this.longitud,
      required this.calificacion,
      required this.categoria,
      required this.descripcion,
      required this.precio,
      required this.imagen,
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
