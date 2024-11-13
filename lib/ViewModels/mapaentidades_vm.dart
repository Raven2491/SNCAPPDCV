import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sncappdcv/models/entidades.dart';
import 'package:sncappdcv/repository/mapaentidades_repository.dart';

class MapaEntidadesVM extends ChangeNotifier {
  final MapaEntidadesRepository mapaEntidadesRepository;

  List<Entidad> entidades = [];
  List<Entidad> entidadesFiltradas = [];
  bool cargandoEntidades = true;
  double proximidad = 0.0;

  MapaEntidadesVM({required this.mapaEntidadesRepository});

  double _calcularDistancia(LatLng posicionAct, LatLng posicionEnt) {
    // Calcular la distancia entre dos posiciones
    proximidad = Geolocator.distanceBetween(
            posicionAct.latitude,
            posicionAct.longitude,
            posicionEnt.latitude,
            posicionEnt.longitude) /
        1000;
    return proximidad;
  }

  Future<List<Entidad>> ubicarEntidades(LatLng posicionActual) async {
    entidades = mapaEntidadesRepository.obtenerEntidades() as List<Entidad>;
    for (var entidad in entidades) {
      entidad.proximidad = _calcularDistancia(
          posicionActual,
          LatLng(
              double.parse(entidad.latitud), double.parse(entidad.longitud)));
    }
    return entidades;
  }

  Future<List<Entidad>> filtrarEntidades() async {
    entidadesFiltradas.clear();
    for (var entidad in entidades) {
      if (entidad.proximidad! >= 0) {
        entidadesFiltradas.add(entidad);
      }
    }
    return entidadesFiltradas;
  }
}
