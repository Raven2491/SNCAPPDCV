import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sncappdcv/Models/entidades.dart';

class EntidadesVM extends ChangeNotifier {
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

  Future<void> obtenerEntidades() async {
    const String url = 'https://endpoint2-blond.vercel.app/entidades';
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

  void filtrarYOrdenarEntidades(String query) {
    List<Entidad> resultados = query.isEmpty
        ? todasEntidades
        : todasEntidades
            .where((entidad) =>
                entidad.razonsocial.toLowerCase().contains(query.toLowerCase()))
            .toList();

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

  void cambiarFiltroSeleccionado(String nuevoFiltro) {
    filtroSeleccionado = nuevoFiltro;
    notifyListeners();
  }
}
