import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:sncappdcv/Widgets/entidades.dart';

class MapaEntidadOpStr2 extends StatefulWidget {
  final LatLng ubicacion;
  final List<Entidad> entidad;
  const MapaEntidadOpStr2(
      {super.key, required this.ubicacion, required this.entidad});

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (contents, constraints) {
      return SizedBox(
        child: FlutterMap(
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
                    color: Colors.blue,
                    size: 30.0,
                  ),
                  point: widget.ubicacion,
                ),
                for (var entidad in widget.entidad)
                  Marker(
                    child: const Icon(
                      FontAwesomeIcons.locationDot,
                      color: Colors.red,
                      size: 30.0,
                    ),
                    point: LatLng(double.parse(entidad.latitud),
                        double.parse(entidad.longitud)),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
