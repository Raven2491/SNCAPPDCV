import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritosManager {
  static const String _favoritosKey = 'favoritos';

  Future<List<String>?> obtenerFavoritos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritosKey);
  }

  Future<void> guardarFavoritos(List<String> favoritos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritosKey, favoritos);
  }

  Future<void> quitarFavorito(String favorito) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoritos = await obtenerFavoritos();

    if (favoritos != null) {
      favoritos.remove(favorito); // Elimina el favorito
      await guardarFavoritos(favoritos); // Guarda la lista actualizada
    }
  }
}

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    _favoritos = await FavoritosManager().obtenerFavoritos();
    setState(() {
      _favoritos = _favoritos ?? [];
    });
  }

  Future<void> _quitarFavorito(String favorito) async {
    await FavoritosManager().quitarFavorito(favorito);
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
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No hay favoritos aún.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      IconButton(
                          onPressed: _cargarFavoritos,
                          icon: const Icon(FontAwesomeIcons.rotateRight)),
                      const Text(
                        'Actualizar',
                        style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                      )
                    ]),
              )
            : Column(
                children: [
                  const SizedBox(height: 10),
                  Row(children: [
                    const Align(
                      //meter un row con un icono y un texto para recargar la pagina
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Favoritos',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: _cargarFavoritos,
                        icon: const Icon(
                          FontAwesomeIcons.rotateRight,
                          size: 18,
                        )),
                  ]),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _favoritos!.length,
                      itemBuilder: (context, index) {
                        String favorito = _favoritos![index];
                        List<String> partes = favorito.split('|');
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
                                      size: 20.0,
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
                                  partes[3] == 'Con autorización'
                                      ? const Icon(Icons.check_circle,
                                          color: Colors.green)
                                      : const Icon(Icons.cancel,
                                          color: Colors.red),
                                  IconButton(
                                    icon:
                                        const Icon(FontAwesomeIcons.heartCrack),
                                    onPressed: () {
                                      _quitarFavorito(favorito);
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {},
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
