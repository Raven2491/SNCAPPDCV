import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:sncappdcv/Widgets/mapaopstr.dart';

class MapaEntidades2 extends StatefulWidget {
  final LatLng posicionActual;
  const MapaEntidades2({super.key, required this.posicionActual});

  @override
  State<MapaEntidades2> createState() => _MapaEntidades2State();
}

class _MapaEntidades2State extends State<MapaEntidades2> {
  final List<String> entidades = [
    'Centros médicos',
    'Escuelas de conductores',
    'Centros de Evaluación',
    'Centros de ITV',
    'Talleres de conversión GNV/GLP',
    'Certificadoras GNV/GLP',
    'Entidades verificadoras',
    'Centros de RPC',
    'Entidad CVC'
  ];

  String? selectedEntidad;
  List<LatLng> ecsalespos = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _ubicarEcsal(String nomecsal) async {
    try {
      String url =
          'https://endpoint2-blond.vercel.app/ubicar?nomEcsal=$nomecsal';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> ecsalpos = json.decode(response.body);
        setState(() {
          ecsalespos = ecsalpos
              .map((item) => LatLng(double.parse(item['Latitud']),
                  double.parse(item['Longitud'])))
              .toList();
          print(ecsalespos);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al ubicar la ecsal, $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Mapa de entidades',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto'),
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          onChanged: (value) {
            setState(() {
              selectedEntidad = value;
            });
          },
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
          items: entidades.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          hint: const Text(
            "Seleccione una entidad...",
            style: TextStyle(fontSize: 14),
          ),
          isExpanded: true,
        ),
        const SizedBox(height: 10),
        Expanded(
          // Usamos Expanded para que ocupe todo el alto disponible
          child: Container(
            width: double.infinity, // Ancho completo
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: ecsalespos.isNotEmpty
                  ? MapaEntidadOpStr(
                      ubicacion: ecsalespos.first,
                    )
                  : widget.posicionActual.latitude == 0 &&
                          widget.posicionActual.longitude == 0
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : MapaEntidadOpStr(
                          ubicacion: widget.posicionActual,
                        ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
