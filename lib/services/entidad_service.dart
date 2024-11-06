import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sncappdcv/models/entidades.dart';
import 'package:sncappdcv/utils/constants.dart';

class EntidadService {
  Future<List<Entidad>> fetchEntidades() async {
    const String url = RapiditoApi.baseUrl + RapiditoApi.entidades;
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // Convertimos la respuesta JSON en una lista de objetos Entidad
      return data.map((json) => Entidad.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar datos');
    }
  }
}
