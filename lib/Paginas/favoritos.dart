import 'package:flutter/material.dart';
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
  const PaginaFavoritos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: FutureBuilder<List<String>?>(
        future: FavoritosManager().obtenerFavoritos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay favoritos aún.'));
          }

          List<String> favoritos = snapshot.data!;

          return ListView.builder(
            itemCount: favoritos.length,
            itemBuilder: (context, index) {
              String favorito = favoritos[index];
              List<String> partes = favorito.split('|');

              return ListTile(
                title: Text(partes[0]), // Razón social
                subtitle: Text('RUC: ${partes[1]}'), // RUC
                trailing: partes[2] == 'Con autorización'
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.cancel, color: Colors.red),
                onTap: () {
                  // Aquí puedes implementar la acción que quieres al tocar el favorito
                  // Por ejemplo, navegar a la página de detalles de esa entidad
                },
              );
            },
          );
        },
      ),
    );
  }
}
