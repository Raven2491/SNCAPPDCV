import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sncappdcv/Paginas/categorias.dart';
import 'package:sncappdcv/Paginas/entidades.dart';
import 'package:sncappdcv/Paginas/inicio.dart';
import 'package:sncappdcv/Paginas/mapaentidades.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const SNCAPP(),
    );
  }
}

class SNCAPP extends StatefulWidget {
  const SNCAPP({super.key});

  @override
  State<SNCAPP> createState() => _SNCAPPState();
}

class _SNCAPPState extends State<SNCAPP> {
  int _indiceBselec = 2;

  final List<Widget> _paginas = [
    const Inicio2(),
    const MapaEntidades(),
    const Inicio2(),
    const Categorias(categoria: ''),
    const EntidadesFiltradas(
      categoria: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
              const ListTile(
                leading: Icon(FontAwesomeIcons.idCard),
                title: Text('Licencias de conducir'),
                /*onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Categorias2(
                                categoria: 'Licencias de conducir',
                              )));
                },*/
              ),
              const ListTile(
                leading: Icon(FontAwesomeIcons.building),
                title: Text('Otras entidades'),
                /*onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Categorias(
                                categoria: 'Otras entidades',
                              )));
                },*/
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: <Widget>[
              /*const SizedBox(height: 16),
              SizedBox(
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
              const SizedBox(height: 16),*/
              Expanded(
                child: IndexedStack(
                  index: _indiceBselec,
                  children: _paginas,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: NavigationBar(
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  FontAwesomeIcons.heart,
                ),
                label: 'Favoritos',
              ),
              NavigationDestination(
                icon: Icon(
                  FontAwesomeIcons.mapLocation,
                ),
                label: 'Mapa',
              ),
              NavigationDestination(
                icon: Icon(
                  FontAwesomeIcons.house,
                ),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(
                  FontAwesomeIcons.list,
                ),
                label: 'Lista',
              ),
              NavigationDestination(
                icon: Icon(
                  FontAwesomeIcons.magnifyingGlass,
                ),
                label: 'Buscar',
              ),
            ],
            selectedIndex: _indiceBselec,
            onDestinationSelected: (int index) {
              setState(() {
                _indiceBselec = index;
              });
            },
            animationDuration: const Duration(milliseconds: 200),
            backgroundColor: Colors.grey[200],
            // Etiqueta seleccionada en blanco
          ),
        ),
      ),
    );
  }
}
