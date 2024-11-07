import 'package:shared_preferences/shared_preferences.dart';

class FavoritosRepository {
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
    List<String>? favoritos = await obtenerFavoritos();
    if (favoritos != null) {
      favoritos.remove(favorito);
      await guardarFavoritos(favoritos);
    }
  }
}
