import 'package:flutter/material.dart';
import 'package:sncappdcv/repository/favoritos_repository.dart';

class FavoritosViewModel extends ChangeNotifier {
  final FavoritosRepository _repository = FavoritosRepository();
  List<String> _favoritos = [];

  List<String> get favoritos => _favoritos;

  Future<void> cargarFavoritos() async {
    _favoritos = await _repository.obtenerFavoritos() ?? [];
    notifyListeners();
  }

  Future<void> agregarAFavoritos(String favorito) async {
    if (!_favoritos.contains(favorito)) {
      _favoritos.add(favorito);
      await _repository.guardarFavoritos(_favoritos);
      notifyListeners();
    }
  }

  Future<void> quitarFavorito(String favorito) async {
    if (_favoritos.contains(favorito)) {
      _favoritos.remove(favorito);
      await _repository.quitarFavorito(favorito);
      notifyListeners();
    }
  }
}
