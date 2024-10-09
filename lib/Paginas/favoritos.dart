import 'package:flutter/material.dart';
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
}

class PaginaFavoritos extends StatelessWidget {
  const PaginaFavoritos({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>?>(
      future: FavoritosManager().obtenerFavoritos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No hay favoritos aún.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        List<String> favoritos = snapshot.data!;

        return Column(children: [
          const SizedBox(
            height: 10,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Favoritos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                String favorito = favoritos[index];
                List<String> partes = favorito.split('|');
                return Column(children: [
                  Card(
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: SizedBox(
                          child: FittedBox(
                            child: Image.asset('assets/images/${partes[0]}',
                                width: 80, height: 80, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      title: Text(
                        partes[1],
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 16.0),
                              Text(partes[4])
                            ]),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(children: [
                              const Icon(
                                FontAwesomeIcons.locationDot,
                                size: 16.0,
                                color: Colors.red,
                              ),
                              Text('${partes[5]} km')
                            ])
                          ]),
                      trailing: partes[3] == 'Con autorización'
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.cancel, color: Colors.red),
                      onTap: () {},
                    ),
                  ),
                ]);
              },
            ),
          ),
        ]);
      },
    );
  }
}
