import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sncappdcv/Widgets/cards.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sncappdcv/Widgets/detentidad.dart';

class EntidadesFiltradas extends StatefulWidget {
  final String categoria;

  const EntidadesFiltradas({super.key, required this.categoria});

  @override
  _EntidadesFiltradasState createState() => _EntidadesFiltradasState();
}

class _EntidadesFiltradasState extends State<EntidadesFiltradas> {
  int _indiceSeleccionado = 0;
  String _filtroSeleccionado = 'A-Z';
  late List<EntidadesCard> entidadesFiltradas;
  late List<EntidadesCard> todasEntidades; // Agrega un FocusNode

  final List<EntidadesCard> entidades = [
    const EntidadesCard(
        nomimagen: 'ecsal_1.jpg',
        razonsocial: 'Brevetes Salud S.A.C',
        direccion: 'Jr. Antenor Orrego 1978',
        categoria: 'Centros médicos',
        precio: 24.0,
        calificacion: 5,
        estado: 'Con autorización',
        proximidad: 0.08,
        coordenadas: const LatLng(-12.058232, -77.060769)),
    const EntidadesCard(
        nomimagen: 'ecsal_1.jpg',
        razonsocial: 'Cala Center S.A.C',
        direccion: 'Jr. Antenor Orrego 1954',
        categoria: 'Centros médicos',
        precio: 22.0,
        calificacion: 5,
        estado: 'Con autorización',
        proximidad: 1.05,
        coordenadas: const LatLng(-12.081128, -77.048400)),
    const EntidadesCard(
        nomimagen: 'ecsal_1.jpg',
        razonsocial: 'Centro Médico Victor Manuel',
        direccion: 'Av. Naciones Unidas N° 1759',
        categoria: 'Centros médicos',
        precio: 28.0,
        calificacion: 5,
        estado: 'Con autorización',
        proximidad: 2.23,
        coordenadas: const LatLng(-12.054520, -77.061687)),
    const EntidadesCard(
        nomimagen: 'esc_cond.jpg',
        razonsocial:
            'Escuela integral de conductores de transporte terrestre Jesus S.A.C.',
        direccion: 'Av. Alfonso Ugarte N° 1346',
        categoria: 'Escuelas de conductores',
        precio: 26.5,
        calificacion: 4,
        estado: 'Inhabilitado',
        proximidad: 2.5,
        coordenadas: const LatLng(-12.057023, -77.041969)),
    const EntidadesCard(
        nomimagen: 'esc_cond.jpg',
        razonsocial: 'JQJQ & Asociados S.A.C.',
        direccion: 'Jr. Breña Urb. Chacra Colorada 145',
        categoria: 'Escuelas de conductores',
        precio: 450.0,
        calificacion: 4,
        estado: 'Con autorización',
        proximidad: 2.6,
        coordenadas: const LatLng(-12.059280, -77.055324)),
    const EntidadesCard(
        nomimagen: 'cent_eval.jpg',
        razonsocial: 'TOURING',
        direccion: 'Av. César Vallejo 638',
        categoria: 'Centros de evaluación',
        precio: 35.0,
        calificacion: 4,
        estado: 'Con autorización',
        proximidad: 2.6,
        coordenadas: const LatLng(-12.089276, -77.038640)),
    const EntidadesCard(
        nomimagen: 'CITV.jpg',
        razonsocial:
            'Centro de inspecciones técnico vehiculares grupo J&J S.A.C.',
        direccion: 'Av. Ruiseñores N°361-393 sub lote A4-1',
        categoria: 'Centros de ITV',
        precio: 400.0,
        calificacion: 4,
        estado: 'Con autorización',
        proximidad: 2.6,
        coordenadas: const LatLng(-12.044755, -77.056625)),
  ];

  final List<String> opciones = [
    'Todas',
    'Centros médicos',
    'Escuelas de conductores',
    'Centros de evaluación',
    'Centros de ITV',
    'Talleres de conversion GNV/GLP',
    'Certificadoras GNV/GLP',
    'Entidad verificadora',
    'Centros de RPC',
    'Entidad CVC'
  ];

  @override
  void initState() {
    super.initState();
    _indiceSeleccionado =
        opciones.indexWhere((opcion) => opcion == widget.categoria);
    if (_indiceSeleccionado == -1) _indiceSeleccionado = 0;

    todasEntidades = entidades;
    if (widget.categoria != 'Todas') {
      entidadesFiltradas = entidades
          .where((entidad) => entidad.categoria == widget.categoria)
          .toList();
    } else {
      entidadesFiltradas = todasEntidades;
    }
  }

  List<EntidadesCard> aplicarFiltros() {
    List<EntidadesCard> filtradas = _indiceSeleccionado == 0
        ? todasEntidades
        : todasEntidades
            .where(
                (entidad) => entidad.categoria == opciones[_indiceSeleccionado])
            .toList();

    switch (_filtroSeleccionado) {
      case 'A-Z':
        filtradas.sort((a, b) => a.razonsocial.compareTo(b.razonsocial));
        break;
      case 'Z-A':
        filtradas.sort((a, b) => b.razonsocial.compareTo(a.razonsocial));
        break;
      case 'Precio más bajo':
        filtradas.sort((a, b) => a.precio.compareTo(b.precio));
        break;
      case 'Precio más alto':
        filtradas.sort((a, b) => b.precio.compareTo(a.precio));
        break;
    }

    return filtradas;
  }

  @override
  Widget build(BuildContext context) {
    final List<EntidadesCard> entidadesOrdenadas = aplicarFiltros();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Buscar entidades...',
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: const Icon(FontAwesomeIcons.arrowDownShortWide),
              onSelected: (String value) {
                setState(() {
                  _filtroSeleccionado = value;
                });
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'A-Z',
                    child: Text('A-Z'),
                  ),
                  const PopupMenuItem(
                    value: 'Z-A',
                    child: Text('Z-A'),
                  ),
                  const PopupMenuItem(
                    value: 'Precio más bajo',
                    child: Text('Precio más bajo'),
                  ),
                  const PopupMenuItem(
                    value: 'Precio más alto',
                    child: Text('Precio más alto'),
                  ),
                ];
              },
            ),
          ]),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(opciones.length, (indice) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _indiceSeleccionado = indice;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: _indiceSeleccionado == indice
                            ? Colors.red
                            : Colors.white,
                        border: Border.all(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        opciones[indice],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: _indiceSeleccionado == indice
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Entidades',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: entidadesOrdenadas.isNotEmpty
                  ? entidadesOrdenadas
                      .map((entidad) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 0),
                            child: GestureDetector(
                                onTap: () {
                                  print(
                                      'Coordenadas de la entidad: ${entidad.coordenadas}');
                                  if (entidad.coordenadas != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetalleEnt(
                                          imagen: entidad.nomimagen,
                                          razonsocial: entidad.razonsocial,
                                          direccion: entidad.direccion,
                                          coordenadas: entidad.coordenadas!,
                                          estado: entidad.estado,
                                          calificacion: entidad.calificacion,
                                          categoria: entidad.categoria,
                                          precio: entidad.precio,
                                          proximidad: entidad.proximidad,
                                          descripcion: entidad.descripcion,
                                        ),
                                      ),
                                    );
                                  } else {
                                    print('Error: Coordenadas son null');
                                  }
                                },
                                child: entidad),
                          ))
                      .toList()
                  : const [
                      Center(
                        child: Text(
                          'No se encontraron entidades',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
            ),
          )
        ],
      ),
    );
  }
}
