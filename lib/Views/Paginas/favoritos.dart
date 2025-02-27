import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:sncappdcv/views/Widgets/detalles_ent.dart';
import 'package:sncappdcv/repository/favoritos_repository.dart';

class PaginaFavoritos extends StatefulWidget {
  const PaginaFavoritos({super.key});

  @override
  _PaginaFavoritosState createState() => _PaginaFavoritosState();
}

class _PaginaFavoritosState extends State<PaginaFavoritos> {
  List<String>? _favoritos;

  @override
  void initState() {
    super.initState();
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    _favoritos = await FavoritosRepository().obtenerFavoritos();
    setState(() {
      _favoritos = _favoritos ?? [];
    });
  }

  Future<void> _quitarFavorito(String favorito) async {
    await FavoritosRepository().quitarFavorito(favorito);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Entidad quitada de favoritos'),
        duration: Duration(seconds: 1),
      ),
    );
    _cargarFavoritos(); // Recargar la lista de favoritos después de quitar uno
  }

  @override
  Widget build(BuildContext context) {
    return _favoritos == null
        ? const Center(child: CircularProgressIndicator())
        : _favoritos!.isEmpty
            ? const Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No hay favoritos aún.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ]),
              )
            : Column(
                children: [
                  const SizedBox(height: 10),
                  const Row(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tus entidades favoritas',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _favoritos!.length,
                      itemBuilder: (context, index) {
                        String favorito = _favoritos![index];
                        List<String> partes = favorito.split('|');
                        String coordenadasLimpiadas = partes[9]
                            .replaceAll('LatLng(latitude:', '')
                            .replaceAll('longitude:', '')
                            .replaceAll(')', '');
                        List<String> coordpartes =
                            coordenadasLimpiadas.split(',');

                        double lat = double.parse(coordpartes[0]);
                        double lon = double.parse(coordpartes[1]);
                        return Column(children: [
                          Card(
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SizedBox(
                                  child: FittedBox(
                                    child: Image.asset(
                                      'assets/images/${partes[0]}',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                partes[1],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RatingBarIndicator(
                                        rating:
                                            double.tryParse(partes[4]) ?? 0.0,
                                        itemCount: 5,
                                        itemSize: 15.0,
                                        direction: Axis.horizontal,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(children: [
                                    const Icon(
                                      FontAwesomeIcons.locationDot,
                                      size: 16.0,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 2.5),
                                    Text(
                                      '${partes[5]} km',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  ])
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  partes[3] == 'CON AUTORIZACION'
                                      ? const Icon(Icons.check_circle,
                                          color: Colors.green)
                                      : const Icon(Icons.cancel,
                                          color: Colors.red),
                                  IconButton(
                                    icon: const Icon(FontAwesomeIcons.trashCan),
                                    tooltip: 'Quitar de favoritos',
                                    onPressed: () {
                                      _quitarFavorito(favorito);
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          DetalleEnt(
                                            imagen: partes[0],
                                            razonsocial: partes[1],
                                            direccion: partes[2],
                                            estado: partes[3],
                                            calificacion:
                                                double.parse(partes[4]),
                                            proximidad: 0.08,
                                            precio: double.parse(partes[6]),
                                            categoria: partes[7],
                                            ruc: partes[8],
                                            coordenadas: LatLng(lat, lon),
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
                                      }),
                                );
                              },
                            ),
                          ),
                        ]);
                      },
                    ),
                  ),
                ],
              );
  }
}
