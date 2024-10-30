import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Editorial1 extends StatefulWidget {
  const Editorial1({super.key});

  @override
  State<Editorial1> createState() => _Editorial1State();
}

class _Editorial1State extends State<Editorial1> {
  int _indiceFselec = 0;
  String _fechaActual = '';
  String _fechaActual2 = '';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null).then((_) {
      setState(() {
        _fechaActual = DateFormat('d \'de\' MMMM \'de\' y', 'es_ES')
            .format(DateTime.now());
        _fechaActual2 = DateFormat('dd/MM/yyyy').format(DateTime.now());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double anchoPantalla = MediaQuery.of(context).size.width;
    return SafeArea(
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
                color: Colors.blue,
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(85.0),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(85.0),
                        ),
                        child: Transform.scale(
                          scale:
                              1.2, // Ajusta el valor para controlar el "zoom"
                          child: Image.asset(
                            'assets/images/nuevalic.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    /*Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rapidito',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '¡Tus entidades a un toque y al toque!',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Builder(
                            builder: (context) {
                              return IconButton(
                                iconSize: 30,
                                icon:
                                    const Icon(Icons.menu, color: Colors.black),
                                onPressed: () {
                                  Scaffold.of(context).openEndDrawer();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),*/
                  ],
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sepa cómo tramitar su licencia de conducir electrónica',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildFiltros('Licencia', 0),
                    const SizedBox(width: 5),
                    _buildFiltros('Electrónica', 1),
                    const SizedBox(width: 5),
                    _buildFiltros('Trámites', 2),
                    Expanded(child: Container()),
                    if (anchoPantalla > 380)
                      Text(_fechaActual, style: const TextStyle(fontSize: 12))
                    else
                      Text(
                        _fechaActual2,
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                /*Text(anchoPantalla.toString()),*/
                const Text(
                  'En esta nota te explicamos los pasos para obtener la licencia de conducir electrónica desde tu casa o trabajo sin necesidad de ir hasta los locales de emisión ni hacer colas.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '¿Cuáles son los requisitos?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                _buildListaTexto(
                    'No debes contar con ningún tipo de multa sin cancelar o sanción pendiente de cumplimiento.'),
                _buildListaTexto(
                    'Debes tener aprobado los exámenes médicos, de conocimientos y de manejo, respectivamente según el tipo de trámite que requieras realizar.'),
                _buildListaTexto('Foto del DNI de ambos lados.'),
                _buildListaTexto('Declaración jurada en formato PDF.'),
                _buildListaTexto(
                    'Autorretrato mostrando la declaración jurada firmada.'),
                _buildListaTexto(
                    'Debes crear tu casilla electrónica del MTC para recibir las notificaciones de la entidad sobre tu trámite.'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFiltros(String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _indiceFselec = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: _indiceFselec == index ? Colors.red : Colors.transparent,
          border: Border.all(
            color: _indiceFselec == index ? Colors.red : Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal,
            color: _indiceFselec == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildListaTexto(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚫',
              style: TextStyle(fontSize: 8, height: 2.9, color: Colors.black)),
          const SizedBox(width: 7.5),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
            ),
          ),
        ],
      ),
    );
  }
}
