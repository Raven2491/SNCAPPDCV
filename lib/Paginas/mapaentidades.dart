import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sncappdcv/Widgets/mapa.dart';

class MapaEntidades extends StatefulWidget {
  final LatLng posicionActual;
  const MapaEntidades({super.key, required this.posicionActual});

  @override
  State<MapaEntidades> createState() => _MapaEntidadesState();
}

class _MapaEntidadesState extends State<MapaEntidades> {
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

  String? selectedDepartamento;
  String? selectedProvincia;
  String? selectedDistrito;

  int indDep = 0;
  int indProv = 0;
  int indDist = 0;

  List<String> departamentos = [];
  List<String> provincias = [];
  List<String> distritos = [];

  String codDep = '';
  String codProv = '';
  String codDist = '';

  @override
  void initState() {
    super.initState();
    selectedDepartamento = null;
    selectedProvincia = null;
    selectedDistrito = null;
    _obtenerDepartamentos();
  }

  Future<void> _obtenerDepartamentos() async {
    try {
      CollectionReference depart =
          FirebaseFirestore.instance.collection('Departamentos');

      QuerySnapshot departSnapshot = await depart.get();

      List<String> departList = departSnapshot.docs
          .map((doc) => (doc['nombre'] as String).toUpperCase())
          .toList();

      setState(() {
        departamentos = departList;
      });
    } catch (e) {
      print("Error al obtener datos: ${e.toString()}");
    }
  }

  Future<void> _obtenerProvincias(String departamento) async {
    try {
      CollectionReference prov = FirebaseFirestore.instance
          .collection('Departamentos')
          .doc(departamento)
          .collection('Provincias');

      QuerySnapshot provSnapshot = await prov.get();

      List<String> provList = provSnapshot.docs
          .map((doc) => (doc['nombre'] as String).toUpperCase())
          .toList();

      setState(() {
        provincias = provList;
        selectedProvincia = null;
      });
    } catch (e) {
      print("Error al obtener datos: $e");
    }
  }

  Future<void> _obtenerDistritos(String departamento, String provincia) async {
    try {
      CollectionReference dist = FirebaseFirestore.instance
          .collection('Departamentos')
          .doc(departamento)
          .collection('Provincias')
          .doc(provincia)
          .collection('Distritos');

      QuerySnapshot distSnapshot = await dist.get();

      List<String> distList = distSnapshot.docs
          .map((doc) => (doc['nombre'] as String).toUpperCase())
          .toList();

      setState(() {
        distritos = distList;
        selectedDistrito = null;
      });
    } catch (e) {
      print("Error al obtener datos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Mapa de entidades',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto'),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Con esta opción podrás visualizar las entidades cercanas a tu ubicación actual. Selecciona una entidad, elige tu ubicación y presiona el botón "Buscar".',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
          ),
          const SizedBox(
            height: 10,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Entidades cercanas:',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto'),
            ),
          ),
          DropdownButtonFormField<String>(
            onChanged: (value) {},
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
          const SizedBox(
            height: 5,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Seleccione ubicación:',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedDepartamento,
                      onChanged: (value) {
                        setState(() {
                          selectedDepartamento = value;
                          indDep =
                              departamentos.indexOf(selectedDepartamento!) + 1;

                          if (selectedDepartamento == null) {
                            codDep = '';
                          } else {
                            codDep =
                                (indDep < 10) ? '0$indDep' : indDep.toString();
                          }

                          provincias = [];
                          selectedProvincia = null;
                          distritos = [];
                          selectedDistrito = null;

                          if (codDep.isNotEmpty) {
                            _obtenerProvincias(codDep);
                          }

                          print(codDep);
                          print(selectedDepartamento);
                        });
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      items: departamentos.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis)),
                        );
                      }).toList(),
                      hint: const Text(
                        "Departamento",
                        style: TextStyle(
                            fontSize: 14, overflow: TextOverflow.ellipsis),
                      ),
                      isExpanded: false,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedProvincia,
                      onChanged: (value) {
                        setState(() {
                          selectedProvincia = value;
                          indProv = provincias.indexOf(selectedProvincia!) + 1;

                          if (selectedProvincia == null) {
                            codProv = '';
                          } else {
                            codProv = (indProv < 10)
                                ? '${codDep}0$indProv'
                                : '$codDep$indProv';
                          }

                          selectedDistrito = null;
                          distritos = [];
                          if (codProv.isNotEmpty) {
                            _obtenerDistritos(codDep, codProv);
                          }
                          print(codProv);
                        });
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      items: provincias.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis)),
                        );
                      }).toList(),
                      hint: const Text(
                        "Provincia",
                        style: TextStyle(
                            fontSize: 14, overflow: TextOverflow.ellipsis),
                      ),
                      isExpanded: false,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedDistrito,
                      onChanged: (value) {
                        setState(() {
                          selectedDistrito = value;
                          indDist = distritos.indexOf(selectedDistrito!) + 1;

                          if (selectedDistrito == null) {
                            codDist = '';
                          } else {
                            codDist = (indDist < 10)
                                ? '${codProv}0$indDist'
                                : '$codProv$indDist';
                          }

                          print(codDist);
                        });
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      items: distritos.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis)),
                        );
                      }).toList(),
                      hint: const Text(
                        "Distrito",
                        style: TextStyle(
                            fontSize: 14, overflow: TextOverflow.ellipsis),
                      ),
                      isExpanded: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print(widget.posicionActual);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Buscar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDepartamento = null;
                        selectedProvincia = null;
                        selectedDistrito = null;
                        indDep = 0;
                        indProv = 0;
                        indDist = 0;
                        codDep = '';
                        codProv = '';
                        codDist = '';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Limpiar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: widget.posicionActual.latitude == 0 &&
                      widget.posicionActual.longitude == 0
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : MapaEntidad(
                      ubicacion: widget.posicionActual,
                    ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
