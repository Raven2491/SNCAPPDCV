import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

class MapaEntidad extends StatefulWidget {
  final LatLng ubicacion;
  const MapaEntidad({super.key, required this.ubicacion});

  @override
  State<MapaEntidad> createState() => MapaEntidadState();
}

class MapaEntidadState extends State<MapaEntidad> {
  final MapController _mapController = MapController();

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
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            MarkerLayer(
              markers: [
                Marker(
                  child: const Icon(
                    FontAwesomeIcons.locationDot,
                    color: Colors.red,
                    size: 25.0,
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
