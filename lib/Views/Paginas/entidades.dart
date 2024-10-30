import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sncappdcv/Views/Widgets/cards.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sncappdcv/Views/Widgets/detentidad.dart';

class Entidades extends StatefulWidget {
  final String categoria;

  const Entidades({super.key, required this.categoria});

  @override
  _EntidadesState createState() => _EntidadesState();
}

class _EntidadesState extends State<Entidades> {
  int _indiceSeleccionado = 0;
  String _filtroSeleccionado = 'A-Z';
  late List<EntidadesCard> entidadesFiltradas;
  late List<EntidadesCard> todasEntidades;

  List<EntidadesCard> entidadesBusqueda = [];

  final TextEditingController _buscarController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

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
        coordenadas: LatLng(-12.058232, -77.060769),
        descripcion:
            'Centro médico especializado en la evaluación de conductores para la obtención de licencias de conducir.'),
    const EntidadesCard(
        nomimagen: 'ecsal_1.jpg',
        razonsocial: 'Cala Center S.A.C',
        direccion: 'Jr. Antenor Orrego 1954',
        categoria: 'Centros médicos',
        precio: 22.0,
        calificacion: 5,
        estado: 'Con autorización',
        proximidad: 1.05,
        coordenadas: LatLng(-12.081128, -77.048400),
        descripcion:
            'Centro médico especializado en la evaluación de conductores para la obtención de licencias de conducir.'),
    const EntidadesCard(
        nomimagen: 'ecsal_1.jpg',
        razonsocial: 'Centro Médico Victor Manuel',
        direccion: 'Av. Naciones Unidas N° 1759',
        categoria: 'Centros médicos',
        precio: 28.0,
        calificacion: 5,
        estado: 'Con autorización',
        proximidad: 2.23,
        coordenadas: LatLng(-12.054520, -77.061687),
        descripcion:
            'Centro médico especializado en la evaluación de conductores para la obtención de licencias de conducir.'),
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
        coordenadas: LatLng(-12.057023, -77.041969),
        descripcion:
            'Escuela de conductores especializada en la formación de conductores profesionales.'),
    const EntidadesCard(
        nomimagen: 'esc_cond.jpg',
        razonsocial: 'JQJQ & Asociados S.A.C.',
        direccion: 'Jr. Breña Urb. Chacra Colorada 145',
        categoria: 'Escuelas de conductores',
        precio: 450.0,
        calificacion: 4,
        estado: 'Con autorización',
        proximidad: 2.6,
        coordenadas: LatLng(-12.059280, -77.055324),
        descripcion:
            'Escuela de conductores especializada en la formación de conductores profesionales.'),
    const EntidadesCard(
        nomimagen: 'cent_eval.jpg',
        razonsocial: 'TOURING',
        direccion: 'Av. Trinidad Moran Nro. 698',
        categoria: 'Centros de evaluación',
        precio: 35.0,
        calificacion: 4,
        estado: 'Con autorización',
        proximidad: 2.6,
        coordenadas: LatLng(-12.089276, -77.038640),
        descripcion:
            'Centro de evaluación de conductores para la obtención de licencias de conducir.'),
    const EntidadesCard(
        nomimagen: 'CITV.jpg',
        razonsocial:
            'CENTRO DE INSPECCIONES TECNICO VEHICULARES J&L SOCIEDAD ANÓNIMA CERRADA - C.I.T.V GRUPO J&L S.A.C',
        direccion: 'Av. Republica de Argentina Nro. 1153',
        categoria: 'Centros de ITV',
        precio: 400.0,
        calificacion: 4,
        estado: 'Con autorización',
        proximidad: 2.6,
        coordenadas: LatLng(-12.051056, -77.129542),
        descripcion:
            'Centro de inspecciones técnico vehiculares para la obtención de certificados de revisión técnica vehicular.'),
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
    entidadesFiltradas = widget.categoria != 'Todas'
        ? entidades
            .where((entidad) => entidad.categoria == widget.categoria)
            .toList()
        : todasEntidades;

    entidadesBusqueda = entidades;
  }

  void _filtrarYOrdenarEntidades(String query) {
    List<EntidadesCard> resultados;

    if (query.isEmpty) {
      resultados = _indiceSeleccionado == 0
          ? todasEntidades
          : todasEntidades
              .where((entidad) =>
                  entidad.categoria == opciones[_indiceSeleccionado])
              .toList();
    } else {
      resultados = todasEntidades
          .where((entidad) =>
              (entidad.razonsocial
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  entidad.categoria
                      .toLowerCase()
                      .contains(query.toLowerCase())) &&
              (_indiceSeleccionado == 0 ||
                  entidad.categoria == opciones[_indiceSeleccionado]))
          .toList();
    }

    switch (_filtroSeleccionado) {
      case 'A-Z':
        resultados.sort((a, b) => a.razonsocial.compareTo(b.razonsocial));
        break;
      case 'Z-A':
        resultados.sort((a, b) => b.razonsocial.compareTo(a.razonsocial));
        break;
      case 'Precio más bajo':
        resultados.sort((a, b) => a.precio.compareTo(b.precio));
        break;
      case 'Precio más alto':
        resultados.sort((a, b) => b.precio.compareTo(a.precio));
        break;
    }

    setState(() {
      entidadesFiltradas = resultados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: _buscarController,
                  focusNode: _focusNode,
                  onChanged: (query) {
                    _filtrarYOrdenarEntidades(query);
                  },
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
                  _filtrarYOrdenarEntidades(_buscarController.text);
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
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _indiceSeleccionado = indice;
                        _filtrarYOrdenarEntidades(_buscarController.text);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _indiceSeleccionado == indice
                            ? Colors.red
                            : Colors.white,
                        border: Border.all(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        opciones[indice],
                        style: TextStyle(
                          fontSize: 13,
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
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (entidadesFiltradas.isEmpty)
            const Center(
              child: Text('No se encontraron entidades'),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: entidadesFiltradas.length,
              itemBuilder: (BuildContext context, int index) {
                final entidad = entidadesFiltradas[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DetalleEnt(
                          imagen: entidad.nomimagen,
                          razonsocial: entidad.razonsocial,
                          ruc: '20476105175',
                          direccion: entidad.direccion,
                          coordenadas: entidad.coordenadas!,
                          estado: entidad.estado,
                          calificacion: entidad.calificacion,
                          categoria: entidad.categoria,
                          precio: entidad.precio,
                          proximidad: entidad.proximidad,
                          descripcion: entidad.descripcion,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          var tween = Tween(begin: begin, end: end);
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: entidad,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
