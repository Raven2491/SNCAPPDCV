import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sncappdcv/Models/entidades.dart';

class EntidadViewModel extends ChangeNotifier {
  List<Entidad> _entidades = [];
  List<Entidad> _entidadesFiltradas = [];
  String _filtroSeleccionado = 'A-Z';

  List<Entidad> get entidades => _entidadesFiltradas;

  Future<void> cargarEntidades() async {
    const String url = 'https://endpoint2-blond.vercel.app/entidades';
    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _entidades = data.map((json) => Entidad.fromJson(json)).toList();
        _entidadesFiltradas = _entidades;
        notifyListeners();
      } else {
        print('Error al obtener datos: ${response.statusCode}');
        throw Exception('Error al cargar datos');
      }
    } catch (e) {
      print('Excepción atrapada: $e');
      throw Exception('Excepción al obtener los datos');
    }
  }

  void filtrarYOrdenarEntidades(String query) {
    _entidadesFiltradas = _entidades.where((entidad) {
      return entidad.razonsocial.toLowerCase().contains(query.toLowerCase());
    }).toList();

    switch (_filtroSeleccionado) {
      case 'A-Z':
        _entidadesFiltradas
            .sort((a, b) => a.razonsocial.compareTo(b.razonsocial));
        break;
      case 'Z-A':
        _entidadesFiltradas
            .sort((a, b) => b.razonsocial.compareTo(a.razonsocial));
        break;
      case 'Precio más bajo':
        _entidadesFiltradas.sort(
            (a, b) => double.parse(a.precio).compareTo(double.parse(b.precio)));
        break;
      case 'Precio más alto':
        _entidadesFiltradas.sort(
            (a, b) => double.parse(b.precio).compareTo(double.parse(a.precio)));
        break;
    }
    notifyListeners();
  }

  void setFiltroSeleccionado(String filtro) {
    _filtroSeleccionado = filtro;
    notifyListeners();
  }
}
