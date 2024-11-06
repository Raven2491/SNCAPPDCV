import 'package:flutter/material.dart';
import 'package:sncappdcv/models/entidades.dart';
import 'package:sncappdcv/repository/entidad_repository.dart';

class EntidadesVM extends ChangeNotifier {
  final EntidadRepository entidadRepository;

  List<Entidad> todasEntidades = [];
  List<Entidad> entidadesFiltradas = [];
  bool cargandoEntidades = true;
  String filtroSeleccionado = 'A-Z';
  int indiceSeleccionado = 0;

  final List<String> opciones = [
    'Todos',
    'Centro medico',
    'Escuela de conductores',
    'Centro de evaluacion',
    'Centro de ITV',
    'Taller de conversion GNV/GLP',
    'Certificadora GNV/GLP',
    'Entidad verificadora',
    'Centro de RPC',
    'Entidad CVC'
  ];

  EntidadesVM({required this.entidadRepository});

  Future<void> obtenerEntidades() async {
    cargandoEntidades = true;
    notifyListeners();

    try {
      todasEntidades = await entidadRepository.obtenerEntidades();
      entidadesFiltradas = todasEntidades;
    } catch (e) {
      print(e);
    } finally {
      cargandoEntidades = false;
      notifyListeners();
    }
  }

  // Método para actualizar la categoría seleccionada
  void actualizarCategoria(int indice) {
    indiceSeleccionado = indice;
    filtrarYOrdenarEntidades('');
  }

  // Método para actualizar el filtro de ordenación
  void actualizarFiltroOrden(String filtro) {
    filtroSeleccionado = filtro;
    filtrarYOrdenarEntidades('');
  }

  // Método para filtrar y ordenar entidades
  void filtrarYOrdenarEntidades(String query) {
    List<Entidad> resultados;

    if (query.isEmpty) {
      resultados = indiceSeleccionado == 0
          ? todasEntidades
          : todasEntidades
              .where((entidad) =>
                  entidad.categoria.toLowerCase() ==
                  opciones[indiceSeleccionado].toLowerCase())
              .toList();
    } else {
      resultados = todasEntidades
          .where((entidad) =>
              (entidad.razonsocial
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  entidad.categoria
                      .toLowerCase()
                      .contains(query.toLowerCase())) &&
              (indiceSeleccionado == 0 ||
                  entidad.categoria.toLowerCase() ==
                      opciones[indiceSeleccionado].toLowerCase()))
          .toList();
    }

    switch (filtroSeleccionado) {
      case 'A-Z':
        resultados.sort((a, b) => a.razonsocial.compareTo(b.razonsocial));
        break;
      case 'Z-A':
        resultados.sort((a, b) => b.razonsocial.compareTo(a.razonsocial));
        break;
      case 'Precio más bajo':
        resultados.sort((a, b) => a.precio.compareTo(b.precio));
        break;
      case 'Precio más alto':
        resultados.sort((a, b) => b.precio.compareTo(a.precio));
        break;
    }

    entidadesFiltradas = resultados;
    notifyListeners();
  }
}
