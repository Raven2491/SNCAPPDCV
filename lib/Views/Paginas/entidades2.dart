import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sncappdcv/Services/entidad_service.dart';
import 'package:sncappdcv/repository/entidad_repository.dart';
import 'package:sncappdcv/viewmodels/entidades_vm.dart';
import 'package:sncappdcv/views/Widgets/cards.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sncappdcv/views/Widgets/detalles_ent.dart';

class Entidades2 extends StatefulWidget {
  final String categoria;

  const Entidades2({super.key, required this.categoria});

  @override
  _Entidades2State createState() => _Entidades2State();
}

class _Entidades2State extends State<Entidades2> {
  int _indiceSeleccionado = 0;
  int _indiceBselec = 4;
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
        estado: 'CON AUTORIZACION',
        proximidad: 0.08,
        coordenadas: LatLng(-12.058232, -77.060769)),
    const EntidadesCard(
        nomimagen: 'ecsal_1.jpg',
        razonsocial: 'Cala Center S.A.C',
        direccion: 'Jr. Antenor Orrego 1954',
        categoria: 'Centros médicos',
        precio: 22.0,
        calificacion: 5,
        estado: 'CON AUTORIZACION',
        proximidad: 1.05,
        coordenadas: LatLng(-12.081128, -77.048400)),
    const EntidadesCard(
        nomimagen: 'ecsal_1.jpg',
        razonsocial: 'Centro Médico Victor Manuel',
        direccion: 'Av. Naciones Unidas N° 1759',
        categoria: 'Centros médicos',
        precio: 28.0,
        calificacion: 5,
        estado: 'CON AUTORIZACION',
        proximidad: 2.23,
        coordenadas: LatLng(-12.054520, -77.061687)),
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
        coordenadas: LatLng(-12.057023, -77.041969)),
    const EntidadesCard(
        nomimagen: 'esc_cond.jpg',
        razonsocial: 'JQJQ & Asociados S.A.C.',
        direccion: 'Jr. Breña Urb. Chacra Colorada 145',
        categoria: 'Escuelas de conductores',
        precio: 450.0,
        calificacion: 4,
        estado: 'CON AUTORIZACION',
        proximidad: 2.6,
        coordenadas: LatLng(-12.059280, -77.055324)),
    const EntidadesCard(
        nomimagen: 'cent_eval.jpg',
        razonsocial: 'TOURING',
        direccion: 'Av. César Vallejo 638',
        categoria: 'Centros de evaluación',
        precio: 35.0,
        calificacion: 4,
        estado: 'CON AUTORIZACION',
        proximidad: 2.6,
        coordenadas: LatLng(-12.089276, -77.038640)),
    const EntidadesCard(
        nomimagen: 'CITV.jpg',
        razonsocial:
            'Centro de inspecciones técnico vehiculares grupo J&J S.A.C.',
        direccion: 'Av. Ruiseñores N°361-393 sub lote A4-1',
        categoria: 'Centros de ITV',
        precio: 400.0,
        calificacion: 4,
        estado: 'CON AUTORIZACION',
        proximidad: 2.6,
        coordenadas: LatLng(-12.044755, -77.056625)),
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

  @override
  Widget build(BuildContext context) {
    final EntidadService entidadService = EntidadService();
    return ChangeNotifierProvider(
      create: (context) {
        final viewModel = EntidadesVM(
            entidadRepository:
                EntidadRepository(entidadService: entidadService));
        viewModel.obtenerEntidades();
        return viewModel;
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
              backgroundColor: Colors.white,
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
                    color: Colors.red,
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
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.building),
                    title: const Text('Historial de entidades'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: Consumer<EntidadesVM>(
                builder: (context, viewModel, child) {
                  return Column(
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
                                viewModel.filtrarYOrdenarEntidades(query);
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
                            /*setState(() {
                              _filtroSeleccionado = value;
                              _filtrarYOrdenarEntidades(_buscarController.text);
                            });*/
                            viewModel.actualizarFiltroOrden(value);
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
                          children: List.generate(viewModel.opciones.length,
                              (indice) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: GestureDetector(
                                onTap: () {
                                  /*setState(() {
                                    _indiceSeleccionado = indice;
                                    _filtrarYOrdenarEntidades(
                                        _buscarController.text);
                                  });*/
                                  viewModel.actualizarCategoria(indice);
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
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      /*if (entidadesFiltradas.isEmpty)
                        const Center(
                          child: Text(
                            'No se encontraron entidades',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),*/
                      if (viewModel.cargandoEntidades)
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                      else if (viewModel.entidadesFiltradas.isEmpty)
                        const Center(
                          child: Text('No se encontraron entidades'),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: viewModel.entidadesFiltradas.length,
                            itemBuilder: (BuildContext context, int index) {
                              final entidad =
                                  viewModel.entidadesFiltradas[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          DetalleEnt(
                                        imagen: entidad.imagen,
                                        razonsocial: entidad.razonsocial,
                                        ruc: entidad.ruc,
                                        categoria: entidad.categoria,
                                        direccion: entidad.direccion,
                                        coordenadas: LatLng(
                                            double.parse(entidad.latitud),
                                            double.parse(entidad.longitud)),
                                        estado: entidad.estado,
                                        precio: double.tryParse(entidad.precio),
                                        descripcion: entidad.descripcion,
                                        proximidad: entidad.proximidad,
                                      ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        var begin = const Offset(1, 0);
                                        var end = Offset.zero;

                                        var tween =
                                            Tween(begin: begin, end: end);

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: FadeTransition(
                                              opacity: animation, child: child),
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
                                  precio:
                                      double.tryParse(entidad.precio) ?? 0.0,
                                  estado: entidad.estado,
                                  proximidad: 0.08,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: NavigationBar(
                destinations: const [
                  NavigationDestination(
                    icon: Icon(
                      FontAwesomeIcons.heart,
                    ),
                    label: 'Favoritos',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      FontAwesomeIcons.mapLocation,
                    ),
                    label: 'Mapa',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      FontAwesomeIcons.house,
                    ),
                    label: 'Inicio',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      FontAwesomeIcons.list,
                    ),
                    label: 'Lista',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      FontAwesomeIcons.magnifyingGlass,
                    ),
                    label: 'Buscar',
                  ),
                ],
                selectedIndex: _indiceBselec,
                onDestinationSelected: (int index) {
                  setState(() {
                    _indiceBselec = index;
                  });
                },
                animationDuration: const Duration(milliseconds: 200),
                backgroundColor: Colors.grey[200],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
