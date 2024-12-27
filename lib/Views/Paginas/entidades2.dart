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
  late final List<EntidadesCard> entidadesFiltradas;
  late List<EntidadesCard> todasEntidades;

  List<EntidadesCard> entidadesBusqueda = [];

  final TextEditingController _buscarController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    final EntidadService entidadService = EntidadService();
    final viewModel = EntidadesVM(
        entidadRepository: EntidadRepository(entidadService: entidadService));
    super.initState();
    _indiceSeleccionado =
        viewModel.opciones.indexWhere((opcion) => opcion == widget.categoria);
    if (_indiceSeleccionado == -1) _indiceSeleccionado = 0;
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
                                    color:
                                        viewModel.indiceSeleccionado == indice
                                            ? Colors.red
                                            : Colors.white,
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    viewModel.opciones[indice],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color:
                                          viewModel.indiceSeleccionado == indice
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
                                            entidad.latitud, entidad.longitud),
                                        estado: entidad.estado,
                                        precio: entidad.precio,
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
                                  precio: entidad.precio ?? 0.0,
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
