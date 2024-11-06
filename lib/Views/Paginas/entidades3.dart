import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:sncappdcv/models/entidades.dart';
import 'package:sncappdcv/views/Widgets/cards.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sncappdcv/views/Widgets/detentidad.dart';

class Entidades3 extends StatefulWidget {
  final String categoria;

  const Entidades3({super.key, required this.categoria});

  @override
  _Entidades3State createState() => _Entidades3State();
}

class _Entidades3State extends State<Entidades3> {
  int _indiceSeleccionado = 0;
  String _filtroSeleccionado = 'A-Z';
  late List<Entidad> entidad = [];
  late List<Entidad> entidadesFiltradas = [];
  late List<Entidad> todasEntidades = [];

  List<Entidad> entidadesBusqueda = [];
  bool _cargandoEntidades = true;

  final TextEditingController _buscarController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<String> opciones = [
    'Todos',
    'Centro medico',
    'Escuela de conductores',
    'Centro de evaluacion',
    'Centro de ITV',
    'Taller de conversion GNV/GLP',
    'Certificadora GNV/GLP',
    'Entidad verificadora',
    'Centro de RPC',
    'Entidad CVC'
  ];

  Future<List<Entidad>> obtenerEntidades() async {
    const String url = 'https://endpoint2-blond.vercel.app/entidades';
    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        entidad = data.map((json) => Entidad.fromJson(json)).toList();

        return entidad;
      } else {
        print('Error al obtener datos: ${response.statusCode}');
        throw Exception('Error al cargar datos');
      }
    } catch (e) {
      print('Excepción atrapada: $e');
      // Muestra un mensaje de error en la UI
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al obtener datos: $e'),
      ));
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _indiceSeleccionado =
        opciones.indexWhere((opcion) => opcion == widget.categoria);
    if (_indiceSeleccionado == -1) _indiceSeleccionado = 0;

    // Carga las entidades desde el servidor al inicializar
    obtenerEntidades().then((entidades) {
      setState(() {
        todasEntidades = entidades;
        entidadesFiltradas = widget.categoria != 'Todas'
            ? entidades
                .where((entidad) => entidad.categoria == widget.categoria)
                .toList()
            : entidades;
        entidadesBusqueda = entidades;
        _cargandoEntidades = false;
      });
    });
  }

  void _filtrarYOrdenarEntidades(String query) {
    List<Entidad> resultados;

    if (query.isEmpty) {
      resultados = _indiceSeleccionado == 0
          ? todasEntidades
          : todasEntidades
              .where((entidad) =>
                  entidad.categoria ==
                  opciones[_indiceSeleccionado].toUpperCase())
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
          if (_cargandoEntidades)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (entidadesFiltradas.isEmpty)
            const Center(
              child: Text('No se encontraron entidades'),
            )
          else
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
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  DetalleEnt(
                            imagen: entidad.imagen,
                            razonsocial: entidad.razonsocial,
                            ruc: entidad.ruc,
                            direccion: entidad.direccion,
                            coordenadas: LatLng(double.parse(entidad.latitud),
                                double.parse(entidad.longitud)),
                            estado: entidad.estado,
                            calificacion: double.tryParse(
                              entidad.calificacion,
                            ),
                            categoria: entidad.categoria,
                            precio: double.tryParse(
                              entidad.precio,
                            ),
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
                    child: EntidadesCard(
                      nomimagen: entidad.imagen,
                      calificacion: 5,
                      razonsocial: entidad.razonsocial,
                      direccion: entidad.direccion,
                      categoria: entidad.categoria,
                      precio: double.tryParse(entidad.precio) ?? 0.0,
                      estado: entidad.estado,
                      proximidad: 0.08,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
