import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sncappdcv/Widgets/cards.dart';
import 'package:sncappdcv/Widgets/mapa.dart';
import 'package:latlong2/latlong.dart';

class DetalleEnt extends StatefulWidget {
  final String? imagen;
  final Image? logo;
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

  const DetalleEnt(
      {super.key,
      this.imagen,
      this.logo,
      required this.razonsocial,
      this.ruc,
      required this.direccion,
      required this.coordenadas,
      required this.categoria,
      required this.precio,
      required this.calificacion,
      required this.estado,
      required this.proximidad,
      this.descripcion});
  @override
  _DetalleEntState createState() => _DetalleEntState();
}

class _DetalleEntState extends State<DetalleEnt> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rapidito',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              Text(
                '¡Tus entidades a un toque y al toque!',
                style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
              ),
            ],
          ),
          backgroundColor: Colors.white.withOpacity(0.8),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 80,
                color: Colors.blue,
                child: const Center(
                  child: Text(
                    'Entidades',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.idCard),
                title: const Text('Licencias de conducir'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.building),
                title: const Text('Otras entidades'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(85.0),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(85.0),
                        ),
                        child: Transform.scale(
                          scale: 1.2,
                          child: Image.asset(
                            'assets/images/${widget.imagen}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DetalleEntCard(
                    razonsocial: widget.razonsocial,
                    ruc: widget.ruc ?? 'N/A',
                    estado: widget.estado,
                    logo: Image.asset('assets/images/logoBS.png')),
                const SizedBox(height: 16),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                            offset: const Offset(0, 4),
                          )
                        ]),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                        child: SizedBox(
                            height: 125,
                            child: MapaEntidad(
                              ubicacion: widget.coordenadas!,
                            )))),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(FontAwesomeIcons.locationDot,
                              color: Colors.red, size: 40.0),
                          const SizedBox(height: 5),
                          Text(widget.direccion,
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          Icon(FontAwesomeIcons.clock,
                              color: Colors.red, size: 40.0),
                          SizedBox(height: 5),
                          Text(
                            'Lunes a sábado de 9:00 a 18:00',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          const Icon(FontAwesomeIcons.moneyBill1,
                              color: Colors.red, size: 40.0),
                          const SizedBox(height: 5),
                          Text(
                            'S/ ${widget.precio.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Descripción',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Centro Médico Brevete & Salud es una entidad empresarial especialista en cuidados de la salud, evaluaciones médicas y psicosomáticas para lograr la obtención de la licencia de conducir y otros sevicios generales relacionados con el bienestar fisico de cada integrante de la sociedad.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Galería',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            'assets/images/${widget.imagen}',
                            fit: BoxFit.cover,
                            height: 100,
                            width: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            'assets/images/${widget.imagen}',
                            fit: BoxFit.cover,
                            height: 100,
                            width: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            'assets/images/${widget.imagen}',
                            fit: BoxFit.cover,
                            height: 100,
                            width: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
