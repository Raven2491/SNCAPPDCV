import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sncappdcv/models/entidades.dart';
import 'package:sncappdcv/utils/constants.dart';

class EntidadService {
  Future<List<Entidad>> fetchEntidades() async {
    const String url = RapiditoApi.listarEnt;
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> entidadesJson = data['Data'];
        return entidadesJson.map((json) => Entidad.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar datos gaaa');
      }
    } catch (e) {
      throw Exception('Error al cargar datos: $e');
    }
  }
}
