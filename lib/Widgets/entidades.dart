class Entidad {
  final String? id;
  final String? distrito;
  final String? ruc;
  final String? razonsocial;
  final String? direccion;
  final String? departamento;
  final String? provincia;
  final String? estado;
  final Ubigeo? ubigeo;

  Entidad(
      {this.id,
      this.distrito,
      this.ruc,
      this.razonsocial,
      this.direccion,
      this.departamento,
      this.provincia,
      this.estado,
      this.ubigeo});

  factory Entidad.fromJson(Map<String, dynamic> json) {
    return Entidad(
      id: json['id'],
      distrito: json['distrito'],
      ruc: json['ruc'],
      razonsocial: json['razonsocial'],
      direccion: json['direccion'],
      departamento: json['departamento'],
      provincia: json['provincia'],
      estado: json['estado'],
      ubigeo: Ubigeo.fromJson(json['ubigeo']),
    );
  }
}

class Ubigeo {
  final double latitude;
  final double longitude;

  Ubigeo({
    required this.latitude,
    required this.longitude,
  });

  factory Ubigeo.fromJson(Map<String, dynamic> json) {
    return Ubigeo(
      latitude: json['_latitude'],
      longitude: json['_longitude'],
    );
  }
}
