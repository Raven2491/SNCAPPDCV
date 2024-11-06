/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sncappdcv/Models/entidades.dart';
import 'package:sncappdcv/Utils/constants.dart';

class EntidadesVM extends ChangeNotifier {
  List<Entidad> todasEntidades = [];
  List<Entidad> entidadesFiltradas = [];
  bool cargandoEntidades = true;
  String filtroSeleccionado = 'A-Z';
  int indiceSeleccionado = 0;
  String apiUrl = RapiditoApi.baseUrl;

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

  Future<void> obtenerEntidades() async {
    const String url = RapiditoApi.baseUrl + RapiditoApi.entidades;
    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        todasEntidades = data.map((json) => Entidad.fromJson(json)).toList();
        entidadesFiltradas = todasEntidades;
        cargandoEntidades = false;
      } else {
        throw Exception('Error al cargar datos');
      }
    } catch (e) {
      cargandoEntidades = false;
      throw Exception('Excepción atrapada: $e');
    }
    notifyListeners();
  }

  // Método para actualizar la categoría seleccionada
  void actualizarCategoria(int indice) {
    indiceSeleccionado = indice;
    filtrarYOrdenarEntidades(''); // Reaplica el filtro al cambiar la categoría
  }

  // Método para actualizar el filtro de ordenación
  void actualizarFiltroOrden(String filtro) {
    filtroSeleccionado = filtro;
    filtrarYOrdenarEntidades(
        ''); // Aplica ordenación sin cambiar el texto de búsqueda
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

    // Ordenar resultados
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
}*/
// lib/viewmodels/entidades_vm.dart

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
      // Manejar el error de alguna forma si es necesario
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
