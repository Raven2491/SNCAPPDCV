import 'package:flutter/material.dart';
import 'package:sncappdcv/Widgets/cards.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sncappdcv/Widgets/detentidad.dart';

class EntidadesFiltradas2 extends StatefulWidget {
  final String categoria;

  const EntidadesFiltradas2({super.key, required this.categoria});

  @override
  _EntidadesFiltradas2State createState() => _EntidadesFiltradas2State();
}

class _EntidadesFiltradas2State extends State<EntidadesFiltradas2> {
  int _indiceSeleccionado = 0;
  String _filtroSeleccionado = 'A-Z';
  late List<EntidadesCard> entidadesFiltradas;
  late List<EntidadesCard> todasEntidades;

  final List<EntidadesCard> entidades = [
    EntidadesCard(
        imagen: Image.asset('assets/images/ecsal_1.jpg'),
        razonsocial: 'Brevetes Salud S.A.C',
        direccion: 'Jr. Antenor Orrego 1978',
        categoria: 'Centros médicos',
        precio: 24.0,
        calificacion: 5,
        estado: 'Con autorización',
        proximidad: 0.08),
    EntidadesCard(
        imagen: Image.asset('assets/images/ecsal_1.jpg'),
        razonsocial: 'Cala Center S.A.C',
        direccion: 'Jr. Antenor Orrego 1954',
        categoria: 'Centros médicos',
        precio: 22.0,
        calificacion: 5,
        estado: 'Con autorización',
        proximidad: 1.05),
    EntidadesCard(
        imagen: Image.asset('assets/images/ecsal_1.jpg'),
        razonsocial: 'Centro Médico Victor Manuel',
        direccion: 'Av. Naciones Unidas N° 1759',
        categoria: 'Centros médicos',
        precio: 28.0,
        calificacion: 5,
        estado: 'Con autorización',
        proximidad: 2.23),
    EntidadesCard(
        imagen: Image.asset('assets/images/esc_cond.jpg'),
        razonsocial:
            'Escuela integral de conductores de transporte terrestre Jesus S.A.C.',
        direccion: 'Av. Alfonso Ugarte N° 1346',
        categoria: 'Escuelas de conductores',
        precio: 26.5,
        calificacion: 4,
        estado: 'Inhabilitado',
        proximidad: 2.5),
    EntidadesCard(
        imagen: Image.asset('assets/images/esc_cond.jpg'),
        razonsocial: 'JQJQ & Asociados S.A.C.',
        direccion: 'Jr. Breña Urb. Chacra Colorada 145',
        categoria: 'Escuelas de conductores',
        precio: 450.0,
        calificacion: 4,
        estado: 'Con autorización',
        proximidad: 2.6),
    EntidadesCard(
        imagen: Image.asset('assets/images/cent_eval.jpg'),
        razonsocial: 'TOURING',
        direccion: 'Av. César Vallejo 638',
        categoria: 'Centros de evaluación',
        precio: 35.0,
        calificacion: 4,
        estado: 'Con autorización',
        proximidad: 2.6),
    EntidadesCard(
        imagen: Image.asset('assets/images/CITV.jpg'),
        razonsocial:
            'Centro de inspecciones técnico vehiculares grupo J&J S.A.C.',
        direccion: 'Av. Ruiseñores N°361-393 sub lote A4-1',
        categoria: 'Centros de ITV',
        precio: 400.0,
        calificacion: 4,
        estado: 'Con autorización',
        proximidad: 2.6),
  ];

  final List<String> opciones = [
    'Todas',
    'Centros médicos',
    'Escuelas de conductores',
    'Centros de evaluación',
    'Centros de ITV',
    'Talleres de conversion GNV/GLP',
    'Certificadoras GNV/GLP',
    'Entidad verificadora',
    'Centros de RPC',
    'Entidad CVC'
  ];

  @override
  void initState() {
    super.initState();
    _indiceSeleccionado =
        opciones.indexWhere((opcion) => opcion == widget.categoria);
    if (_indiceSeleccionado == -1) _indiceSeleccionado = 0;

    todasEntidades = entidades;
    if (widget.categoria != 'Todas') {
      entidadesFiltradas = entidades
          .where((entidad) => entidad.categoria == widget.categoria)
          .toList();
    } else {
      entidadesFiltradas = todasEntidades;
    }
  }

  List<EntidadesCard> aplicarFiltros() {
    List<EntidadesCard> filtradas = _indiceSeleccionado == 0
        ? todasEntidades
        : todasEntidades
            .where(
                (entidad) => entidad.categoria == opciones[_indiceSeleccionado])
            .toList();

    switch (_filtroSeleccionado) {
      case 'A-Z':
        filtradas.sort((a, b) => a.razonsocial.compareTo(b.razonsocial));
        break;
      case 'Z-A':
        filtradas.sort((a, b) => b.razonsocial.compareTo(a.razonsocial));
        break;
      case 'Precio más bajo':
        filtradas.sort((a, b) => a.precio.compareTo(b.precio));
        break;
      case 'Precio más alto':
        filtradas.sort((a, b) => b.precio.compareTo(a.precio));
        break;
    }

    return filtradas;
  }

  @override
  Widget build(BuildContext context) {
    final List<EntidadesCard> entidadesOrdenadas = aplicarFiltros();
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
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
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(FontAwesomeIcons.building),
                  title: const Text('Otras entidades'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: 'Buscar entidades...',
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    icon: const Icon(FontAwesomeIcons.arrowDownShortWide),
                    onSelected: (String value) {
                      setState(() {
                        _filtroSeleccionado = value;
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem(
                          value: 'A-Z',
                          child: Text('A-Z'),
                        ),
                        const PopupMenuItem(
                          value: 'Z-A',
                          child: Text('Z-A'),
                        ),
                        const PopupMenuItem(
                          value: 'Precio más bajo',
                          child: Text('Precio más bajo'),
                        ),
                        const PopupMenuItem(
                          value: 'Precio más alto',
                          child: Text('Precio más alto'),
                        ),
                      ];
                    },
                  ),
                ]),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(opciones.length, (indice) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _indiceSeleccionado = indice;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: _indiceSeleccionado == indice
                                  ? Colors.red
                                  : Colors.white,
                              border: Border.all(
                                color: Colors.red,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              opciones[indice],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: _indiceSeleccionado == indice
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Entidades',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: entidadesOrdenadas.isNotEmpty
                        ? entidadesOrdenadas
                            .map((entidad) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 0),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetalleEnt(
                                              razonsocial: entidad.razonsocial,
                                              direccion: entidad.direccion,
                                              coordenadas: entidad.coordenadas,
                                              estado: entidad.estado,
                                              calificacion:
                                                  entidad.calificacion,
                                              categoria: entidad.categoria,
                                              precio: entidad.precio,
                                              proximidad: entidad.proximidad,
                                              descripcion: entidad.descripcion,
                                            ),
                                          ),
                                        );
                                      },
                                      child: entidad),
                                ))
                            .toList()
                        : const [
                            Center(
                              child: Text(
                                'No se encontraron entidades',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
