import 'package:sncappdcv/Services/entidad_service.dart';
import 'package:sncappdcv/models/entidades.dart';

class EntidadRepository {
  final EntidadService entidadService;

  EntidadRepository({required this.entidadService});

  Future<List<Entidad>> obtenerEntidades() async {
    try {
      List<Entidad> entidades = [];
      entidades = await entidadService.fetchEntidades();
      return entidades;
    } catch (e) {
      throw Exception('Error al obtener entidades: $e');
    }
  }
}
