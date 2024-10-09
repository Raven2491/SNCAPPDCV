import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

class CategoriaCard extends StatelessWidget {
  final Image imagen;
  final String entidad;
  final String tipo;
  final String cantidad;
  final int views;

  const CategoriaCard({
    super.key,
    required this.imagen,
    required this.entidad,
    required this.tipo,
    required this.cantidad,
    required this.views,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      //color: const Color(0xFFFBEDED),
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                width: 50,
                height: 50,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: imagen,
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    entidad,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  Text(
                    cantidad,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EntidadesCard extends StatelessWidget {
  final String? nomimagen;
  final Image? nomlogo;
  final String razonsocial;
  final String? ruc;
  final String direccion;
  final LatLng? coordenadas;
  final String categoria;
  final double precio;
  final double calificacion;
  final String estado;
  final double proximidad;
  final String? descripcion;

  const EntidadesCard({
    super.key,
    this.nomimagen,
    this.nomlogo,
    required this.razonsocial,
    this.ruc,
    required this.direccion,
    this.coordenadas,
    required this.categoria,
    required this.precio,
    required this.calificacion,
    required this.estado,
    required this.proximidad,
    this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        //color: const Color(0xFFFBEDED),
        color: Colors.white,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox(
                    width: 80,
                    height: 80,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.asset('assets/images/$nomimagen'),
                    )),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      razonsocial,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      direccion,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'S/. ${precio.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16.0),
                        Text(
                          calificacion.toString(),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  if (estado == 'Con autorización')
                    Image.asset('assets/images/puntoverde.png',
                        width: 20, height: 20, fit: BoxFit.cover)
                  else
                    Image.asset('assets/images/puntorojo.png',
                        width: 20, height: 20, fit: BoxFit.cover),
                  const SizedBox(height: 45.0),
                  Row(children: [
                    Text(
                      '${proximidad.toStringAsFixed(2)} km',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    const Icon(
                      FontAwesomeIcons.locationDot,
                      size: 16.0,
                      color: Colors.red,
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetalleEntCard extends StatelessWidget {
  final Image? logo;
  final String razonsocial;
  final String ruc;
  final String estado;

  const DetalleEntCard(
      {super.key,
      this.logo,
      required this.razonsocial,
      required this.ruc,
      required this.estado});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                    offset: const Offset(0, 3),
                  )
                  //
                ],
              ),
              child: ClipOval(
                child: SizedBox(
                    width: 40,
                    height: 40,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: logo,
                    )),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    razonsocial,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ruc,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                ],
              ),
            ),
            if (estado == 'Con autorización')
              Image.asset('assets/images/puntoverde.png',
                  width: 25, height: 25, fit: BoxFit.cover)
            else
              Image.asset('assets/images/puntorojo.png',
                  width: 25, height: 25, fit: BoxFit.cover),
            const SizedBox(height: 45.0),
          ],
        ),
      ),
    );
  }
}
