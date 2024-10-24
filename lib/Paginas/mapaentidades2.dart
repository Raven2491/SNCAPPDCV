import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sncappdcv/Widgets/entidades.dart';
import 'package:sncappdcv/Widgets/mapaopstr.dart';
import 'package:sncappdcv/Widgets/mapaopstr2.dart';

class MapaEntidades2 extends StatefulWidget {
  final LatLng posicionActual;
  const MapaEntidades2({super.key, required this.posicionActual});

  @override
  State<MapaEntidades2> createState() => _MapaEntidades2State();
}

class _MapaEntidades2State extends State<MapaEntidades2> {
  final List<String> catEntidades = [
    'Centros médicos',
    'Escuelas de conductores',
    'Centros de Evaluación',
    'Centros de ITV',
    'Talleres de conversión GNV/GLP',
    'Certificadoras GNV/GLP',
    'Entidades verificadoras',
    'Centros de RPC',
    'Entidad CVC'
  ];

  String? selectedEntidad;
  List<LatLng> ecsalespos = [];
  List<Entidad> entidades = [];
  List<Entidad> entidadesfiltradas = [];
  late Future<List<Entidad>>
      futureEntidades; // Nueva variable para almacenar el futuro de las entidades

  final Distance distancia = Distance();
  double proximidad = 0.0;

  @override
  void initState() {
    super.initState();
    // Cargar entidades solo una vez cuando el widget se inicializa
    futureEntidades = obtenerEntidades();
  }

  Future<List<Entidad>> obtenerEntidades() async {
    const String url = 'https://endpoint2-blond.vercel.app/entidades';
    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        entidades = data.map((json) => Entidad.fromJson(json)).toList();

        for (var entidad in entidades) {
          entidad.proximidad = _calcularDistancia(
              widget.posicionActual,
              LatLng(double.parse(entidad.latitud),
                  double.parse(entidad.longitud)));
        }

        return entidades;
      } else {
        print('Error al obtener datos: ${response.statusCode}');
        throw Exception('Error al cargar datos');
      }
    } catch (e) {
      print('Excepción atrapada: $e');
      throw Exception('Excepción al obtener los datos');
    }
  }

  Future<List<Entidad>> filtrarEntidades() async {
    entidadesfiltradas.clear();
    for (var entidad in entidades) {
      if (entidad.proximidad! >= 0) {
        entidadesfiltradas.add(entidad);
      }
    }
    return entidadesfiltradas;
  }

  Future<void> _ubicarEcsal(String nomecsal) async {
    try {
      String url =
          'https://endpoint2-blond.vercel.app/ubicar?nomEcsal=$nomecsal';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> ecsalpos = json.decode(response.body);
        setState(() {
          ecsalespos = ecsalpos
              .map((item) => LatLng(double.parse(item['Latitud']),
                  double.parse(item['Longitud'])))
              .toList();
          print(ecsalespos);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al ubicar la ecsal, $e');
    }
  }

  double _calcularDistancia(LatLng posicionAct, LatLng posicionEnt) {
    // Calcular la distancia entre dos posiciones
    proximidad = Geolocator.distanceBetween(
            posicionAct.latitude,
            posicionAct.longitude,
            posicionEnt.latitude,
            posicionEnt.longitude) /
        1000;
    return proximidad;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Entidad>>(
        future: futureEntidades, // Usamos la variable futureEntidades
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar las entidades'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            entidades = snapshot.data!;
            filtrarEntidades();
            return Column(children: [
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mapa de entidades',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                isDense: true,
                onChanged: (value) {
                  // Cambia solo la entidad seleccionada
                  setState(() {
                    selectedEntidad = value;
                  });
                },
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                items: catEntidades.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: const Text(
                  "Seleccione una entidad...",
                  style: TextStyle(fontSize: 14),
                ),
                isExpanded: true,
              ),
              const SizedBox(height: 10),
              Expanded(
                // Usamos Expanded para que ocupe todo el alto disponible
                child: Container(
                  width: double.infinity, // Ancho completo
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: ecsalespos.isNotEmpty
                        ? MapaEntidadOpStr(
                            ubicacion: ecsalespos.first,
                          )
                        : widget.posicionActual.latitude == 0 &&
                                widget.posicionActual.longitude == 0
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : MapaEntidadOpStr2(
                                ubicacion: widget.posicionActual,
                                entidad: entidades),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapaEntidades2(
                                posicionActual: widget.posicionActual,
                              )));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Busqueda avanzada',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 5),
            ]);
          } else {
            return const Center(
              child: Text('No se encontraron entidades'),
            );
          }
        });
  }
}
