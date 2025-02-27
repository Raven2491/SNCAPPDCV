import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:sncappdcv/models/entidades.dart';

class MapaEntidadOpStr2 extends StatefulWidget {
  final LatLng ubicacion;
  final List<Entidad> entidad;
  final String categoria;
  const MapaEntidadOpStr2(
      {super.key,
      required this.ubicacion,
      required this.entidad,
      required this.categoria});

  @override
  State<MapaEntidadOpStr2> createState() => MapaEntidadOpStr2State();
}

class MapaEntidadOpStr2State extends State<MapaEntidadOpStr2> {
  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(MapaEntidadOpStr2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ubicacion != oldWidget.ubicacion) {
      _mapController.move(widget.ubicacion, 16);
    }
  }

  /*@override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (contents, constraints) {
      return FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialZoom: 15.5,
          initialCenter: widget.ubicacion,
        ),
        children: [
          TileLayer(
            tileProvider: CancellableNetworkTileProvider(),
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          if (widget.categoria == 'TODAS')
            MarkerLayer(markers: [
              Marker(
                child: const Icon(
                  FontAwesomeIcons.locationDot,
                  color: Color.fromARGB(255, 224, 42, 42),
                  size: 30.0,
                ),
                point: widget.ubicacion,
              ),
              for (var entidad in widget.entidad) ...[
                if (entidad.categoria == 'CENTRO MEDICO')
                  Marker(
                    child: const Icon(
                      FontAwesomeIcons.houseMedical,
                      color: Color.fromARGB(255, 224, 42, 42),
                      size: 30.0,
                    ),
                    point: LatLng(double.parse(entidad.latitud),
                        double.parse(entidad.longitud)),
                  )
                else if (entidad.categoria == 'ESCUELA DE CONDUCTORES')
                  Marker(
                    child: const Icon(
                      FontAwesomeIcons.car,
                      color: Color.fromARGB(255, 224, 42, 42),
                      size: 30.0,
                    ),
                    point: LatLng(double.parse(entidad.latitud),
                        double.parse(entidad.longitud)),
                  )
                else if (entidad.categoria == 'CENTRO DE EVALUACION')
                  Marker(
                    child: const Icon(
                      FontAwesomeIcons.clipboardCheck,
                      color: Color.fromARGB(255, 224, 42, 42),
                      size: 30.0,
                    ),
                    point: LatLng(double.parse(entidad.latitud),
                        double.parse(entidad.longitud)),
                  )
                else if (entidad.categoria == 'CENTRO DE ITV')
                  Marker(
                    child: const Icon(
                      FontAwesomeIcons.toolbox,
                      color: Color.fromARGB(255, 224, 42, 42),
                      size: 30.0,
                    ),
                    point: LatLng(double.parse(entidad.latitud),
                        double.parse(entidad.longitud)),
                  )
              ],
            ])
        ],
      );
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (contents, constraints) {
      return FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialZoom: 15.5,
          initialCenter: widget.ubicacion,
        ),
        children: [
          TileLayer(
            tileProvider: CancellableNetworkTileProvider(),
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          MarkerLayer(
            markers: [
              Marker(
                child: const Icon(
                  FontAwesomeIcons.locationDot,
                  color: Color.fromARGB(255, 224, 42, 42),
                  size: 30.0,
                ),
                point: widget.ubicacion,
              ),
              // Filtrar entidades por categoría
              for (var entidad in widget.entidad)
                if (widget.categoria == 'TODAS' ||
                    entidad.categoria == widget.categoria)
                  Marker(
                    child: Icon(
                      _getIconForCategory(entidad.categoria),
                      color: const Color.fromARGB(255, 224, 42, 42),
                      size: 30.0,
                    ),
                    point: LatLng(entidad.latitud, entidad.longitud),
                  ),
            ],
          ),
        ],
      );
    });
  }

// Método auxiliar para obtener el icono correspondiente según la categoría
  IconData _getIconForCategory(String categoria) {
    switch (categoria) {
      case 'CENTRO MEDICO':
        return FontAwesomeIcons.houseMedical;
      case 'ESCUELA DE CONDUCTORES':
        return FontAwesomeIcons.car;
      case 'CENTRO DE EVALUACION':
        return FontAwesomeIcons.clipboardCheck;
      case 'CENTRO DE ITV':
        return FontAwesomeIcons.toolbox;
      default:
        return FontAwesomeIcons.locationDot;
    }
  }
}
