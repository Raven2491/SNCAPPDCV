import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sncappdcv/Services/entidad_service.dart';
import 'package:sncappdcv/viewmodels/entidades_vm.dart';
import 'package:sncappdcv/views/Widgets/cards.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sncappdcv/views/Widgets/detalles_ent.dart';
import 'package:sncappdcv/repository/entidad_repository.dart';

class Entidades4 extends StatelessWidget {
  final String categoria;

  const Entidades4({super.key, required this.categoria});

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
      child: Consumer<EntidadesVM>(
        builder: (context, viewModel, child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 16),
                // Búsqueda y Ordenamiento
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextField(
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
                  ],
                ),

                const SizedBox(height: 16),

                // Categorías
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        List.generate(viewModel.opciones.length, (indice) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            viewModel.actualizarCategoria(indice);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: viewModel.indiceSeleccionado == indice
                                  ? Colors.red
                                  : Colors.white,
                              border: Border.all(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              viewModel.opciones[indice],
                              style: TextStyle(
                                fontSize: 13,
                                color: viewModel.indiceSeleccionado == indice
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
                // Lista de Entidades
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
                        final entidad = viewModel.entidadesFiltradas[index];
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

                                  var tween = Tween(begin: begin, end: end);

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
        },
      ),
    );
  }
}
