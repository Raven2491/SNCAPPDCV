class Entidad {
  final String? distrito;
  final String? ruc;
  final String? razonsocial;
  final String? direccion;
  final String? departamento;
  final String? provincia;
  final String? estado;
  final String? latitud;
  final String? longitud;
  final String? distancia;
  final String? calificacion;
  final String? categoria;
  final String? descripcion;
  final String? precio;
  final String? imagen;

  Entidad(
      {this.distrito,
      this.ruc,
      this.razonsocial,
      this.direccion,
      this.departamento,
      this.provincia,
      this.estado,
      this.latitud,
      this.longitud,
      this.distancia,
      this.calificacion,
      this.categoria,
      this.descripcion,
      this.precio,
      this.imagen});

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
        distancia: json['distancia'],
        calificacion: json['calificacion'],
        categoria: json['categoria'],
        descripcion: json['descripcion'],
        precio: json['precio'],
        imagen: json['nomimagen']);
  }
}
