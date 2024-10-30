import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

class MapaEntidadOpStr extends StatefulWidget {
  final LatLng ubicacion;
  const MapaEntidadOpStr({super.key, required this.ubicacion});

  @override
  State<MapaEntidadOpStr> createState() => MapaEntidadOpStrState();
}

class MapaEntidadOpStrState extends State<MapaEntidadOpStr> {
  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(MapaEntidadOpStr oldWidget) {
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
                    color: Color.fromARGB(255, 224, 42, 42),
                    size: 30.0,
                  ),
                  point: widget.ubicacion,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
