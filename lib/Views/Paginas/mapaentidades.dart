import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:sncappdcv/views/Widgets/detalles_ent.dart';
import 'package:sncappdcv/views/Widgets/mapaopstr.dart';

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

  String? selectedEntidad;
  String? selectedDepartamento;
  String? selectedProvincia;
  String? selectedDistrito;
  String? selectedEcsal;

  int indDep = 0;
  int indProv = 0;
  int indDist = 0;

  List<String> departamentos = [];
  List<String> provincias = [];
  List<String> distritos = [];
  List<String> ecsalesnom = [];
  List<LatLng> ecsalespos = [];

  String codDep = '';
  String codProv = '';
  String codDist = '';

  bool departamentosCargado = false;

  String? nomimagen;
  Image? nomlogo;
  String razonsocial = '';
  String ruc = '';
  String? direccion = '';
  LatLng? coordenadas;
  String? categoria;
  double? precio;
  double? calificacion;
  String estado = '';
  double? proximidad;
  String descripcion = '';

  int _indiceFselec = 0;

  final List<String> opciones = [
    'Todas',
    'Licencias de conducir',
    'Otras entidades'
  ];
  @override
  void initState() {
    super.initState();
    selectedEntidad = null;
    selectedDepartamento = null;
    selectedProvincia = null;
    selectedDistrito = null;
    _obtenerDepartamentos();
  }

  Future<void> _obtenerDepartamentos() async {
    try {
      const String url = 'https://endpoint2-blond.vercel.app/dep';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> departList = json.decode(response.body);
        setState(() {
          departamentos = departList
              .map((item) => item['nombre'].toString().toUpperCase())
              .toList();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener los departamentos, $e');
    }
  }

  Future<void> _obtenerProvincias(String idDep) async {
    try {
      final String url = 'https://endpoint2-blond.vercel.app/prov?idDep=$idDep';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> provList = json.decode(response.body);
        setState(() {
          provincias = provList
              .map((item) => item['nombre'].toString().toUpperCase())
              .toList();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener las provincias, $e');
    }
  }

  Future<void> _obtenerDistritos(String idDep, String idProv) async {
    try {
      final String url =
          'https://endpoint2-blond.vercel.app/dist?idDep=$idDep&idProv=$idProv';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> distList = json.decode(response.body);
        setState(() {
          distritos = distList
              .map((item) => item['nombre'].toString().toUpperCase())
              .toList();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener las provincias, $e');
    }
  }

  Future<void> _obtenerEcsales(
      String departamento, String provincia, String distrito) async {
    try {
      final String url =
          'https://endpoint2-blond.vercel.app/ecsales?dep=$departamento&prov=$provincia&dist=$distrito';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> ecsaleslist = json.decode(response.body);
        setState(() {
          ecsalesnom = ecsaleslist
              .map((item) => item['razonsocial'].toString().toUpperCase())
              .toList();

          if (ecsalesnom.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 1),
                content: Text(
                    'No se encontraron establecimientos en la ubicación seleccionada.'),
              ),
            );
          }
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener las ecsales, $e');
    }
  }

  Future<void> _ubicarEcsal(String nomecsal) async {
    try {
      String url =
          'https://endpoint2-blond.vercel.app/ubicar?nomEcsal=$nomecsal';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> ecsalpos = json.decode(response.body);
        setState(() {
          //print(ecsalpos);
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

  Future<void> _mostrarEcsal(String nomecsal) async {
    try {
      String url =
          'https://endpoint2-blond.vercel.app/infoEcsal?nomEcsal=$nomecsal';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> ecsalinfo = json.decode(response.body);

        if (ecsalinfo.isNotEmpty) {
          setState(() {
            razonsocial = ecsalinfo[0]['razonsocial'];
            ruc = ecsalinfo[0]['ruc'];
            direccion = ecsalinfo[0]['direccion'];
            coordenadas = LatLng(double.parse(ecsalinfo[0]['Latitud']),
                double.parse(ecsalinfo[0]['Longitud']));
            estado = ecsalinfo[0]['estado'];
            descripcion = ecsalinfo[0]['descripcion'];
          });
        } else {
          print('No se encontró información de la entidad');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener la información de la ecsal, $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rapidito',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                Text(
                  '¡Tus entidades a un toque y al toque!',
                  style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ),
            ],
          ),
          endDrawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 80,
                  color: Colors.red,
                  child: const Center(
                    child: Text(
                      'Entidades',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(FontAwesomeIcons.idCard),
                  title: const Text('Licencias de conducir'),
                  onTap: () {
                    setState(() {
                      _indiceFselec = opciones.indexOf('Licencias de conducir');
                      Navigator.of(context).pop();
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(FontAwesomeIcons.building),
                  title: const Text('Otras entidades'),
                  onTap: () {
                    setState(() {
                      _indiceFselec = opciones.indexOf('Otras entidades');
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Búsqueda avanzada de entidades',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Aqui puedes buscar las entidades más cercanas a tu ubicación actual. Selecciona un tipo de entidad, elige tu ubicación y presiona el botón "Buscar".',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Seleccione una entidad:',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                ),
              ),
              DropdownButtonFormField<String>(
                onChanged: (value) {
                  setState(() {
                    selectedEntidad = value;
                    departamentosCargado = value != null;
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
              const SizedBox(
                height: 10,
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
                          onChanged: departamentosCargado
                              ? (value) {
                                  setState(() {
                                    selectedDepartamento = value;
                                    indDep = departamentos
                                            .indexOf(selectedDepartamento!) +
                                        1;

                                    if (selectedDepartamento == null) {
                                      codDep = '';
                                    } else {
                                      codDep = (indDep < 10)
                                          ? '0$indDep'
                                          : indDep.toString();
                                    }

                                    provincias = [];
                                    selectedProvincia = null;
                                    distritos = [];
                                    selectedDistrito = null;

                                    if (codDep.isNotEmpty) {
                                      _obtenerProvincias(codDep);
                                    }
                                    //print(codDep);
                                    //print(selectedDepartamento);
                                  });
                                }
                              : null,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                          items: (departamentos.cast<String>())
                              .map((String value) {
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
                              indProv =
                                  provincias.indexOf(selectedProvincia!) + 1;

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
                              //print(codProv);
                            });
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                          items:
                              (provincias.cast<String>()).map((String value) {
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
                              indDist =
                                  distritos.indexOf(selectedDistrito!) + 1;

                              if (selectedDistrito == null) {
                                codDist = '';
                              } else {
                                codDist = (indDist < 10)
                                    ? '${codProv}0$indDist'
                                    : '$codProv$indDist';
                              }

                              //print(codDist);
                            });
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                          items: (distritos.cast<String>()).map((String value) {
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
                          if (selectedDepartamento == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text(
                                    'Debe seleccionar un departamento para realizar la búsqueda.'),
                              ),
                            );
                            return;
                          }
                          String provincia = '';
                          String distrito = '';

                          if (selectedProvincia != null) {
                            provincia = selectedProvincia!;
                          }

                          if (selectedDistrito != null) {
                            distrito = selectedDistrito!;
                          }
                          ecsalesnom = [];
                          print(
                              '$selectedDepartamento $selectedProvincia $selectedDistrito');
                          _obtenerEcsales(
                              selectedDepartamento!, provincia, distrito);
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
                            ecsalesnom = [];
                            ecsalespos = [];
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
              Column(
                children: [
                  if (ecsalesnom.isNotEmpty) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Establecimientos encontrados:',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto'),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      onChanged: (value) {
                        setState(() {
                          selectedEcsal = value;
                        });
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      items: ecsalesnom.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                          onTap: () {
                            print(value);
                            _ubicarEcsal(value);
                          },
                        );
                      }).toList(),
                      hint: const Text(
                        "Seleccione un establecimiento",
                        style: TextStyle(fontSize: 14),
                      ),
                      isExpanded: true,
                    ),
                  ]
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
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: selectedEcsal != null
                    ? () async {
                        await _mostrarEcsal(selectedEcsal!);
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        DetalleEnt(
                                          //imagen: entidad.nomimagen,
                                          razonsocial: razonsocial,
                                          ruc: ruc,
                                          direccion: direccion,
                                          coordenadas: coordenadas,
                                          estado: estado,
                                          //calificacion: entidad.calificacion,
                                          //categoria: entidad.categoria,
                                          //precio: entidad.precio,
                                          //proximidad: ,
                                          descripcion: descripcion,
                                        ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = const Offset(1, 0);
                                  var end = Offset.zero;

                                  var tween = Tween(begin: begin, end: end);

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: FadeTransition(
                                        opacity: animation, child: child),
                                  );
                                }));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Más información',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
