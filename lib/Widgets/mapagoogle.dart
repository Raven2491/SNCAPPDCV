import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart' as latlng;

class MapaEntidadGoogle extends StatefulWidget {
  final latlng.LatLng ubicacion;

  const MapaEntidadGoogle({super.key, required this.ubicacion});

  @override
  State<MapaEntidadGoogle> createState() => MapaEntidadGoogleState();
}

class MapaEntidadGoogleState extends State<MapaEntidadGoogle> {
  late gmaps.GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    // Convertir LatLng de latlong2 a LatLng de google_maps_flutter
    gmaps.LatLng googleMapLatLng =
        gmaps.LatLng(widget.ubicacion.latitude, widget.ubicacion.longitude);

    return Scaffold(
      body: gmaps.GoogleMap(
        onMapCreated: (gmaps.GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: gmaps.CameraPosition(
          target: googleMapLatLng,
          zoom: 15.5,
        ),
        markers: {
          gmaps.Marker(
            markerId: const gmaps.MarkerId('locationMarker'),
            position: googleMapLatLng,
            icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
                gmaps.BitmapDescriptor.hueRed),
          ),
        },
      ),
    );
  }
}
