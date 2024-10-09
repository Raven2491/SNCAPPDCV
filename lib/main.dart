import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sncappdcv/Paginas/categorias.dart';
import 'package:sncappdcv/Paginas/categorias2.dart';
import 'package:sncappdcv/Paginas/entidades.dart';
import 'package:sncappdcv/Paginas/favoritos.dart';
import 'package:sncappdcv/Paginas/inicio.dart';
import 'package:sncappdcv/Paginas/mapaentidades.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
      home: const PantallaCarga(),
    );
  }
}

class PantallaCarga extends StatefulWidget {
  const PantallaCarga({super.key});

  @override
  State<PantallaCarga> createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const SNCAPP()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Rapidito!',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(
              width: 110,
              height: 55,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset(
                  'assets/images/mtclogo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
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

  List<Widget> _paginas = [];

  LatLng posicionActual = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _paginas = [
      const PaginaFavoritos(),
      MapaEntidades(
        posicionActual: posicionActual,
      ),
      const Inicio2(),
      const Categorias(categoria: ''),
      const Entidades(
        categoria: 'Todas',
      ),
    ];

    _determinarPosicion().then((posicion) {
      setState(() {
        posicionActual = LatLng(posicion.latitude, posicion.longitude);
        // Actualizamos la página del mapa con la posición obtenida
        _paginas[1] = MapaEntidades(posicionActual: posicionActual);
      });
    }).catchError((error) {
      print('Error obteniendo posición: $error');
    });
  }

  Future<Position> _determinarPosicion() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('El servicio de ubicación está deshabilitado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permiso de ubicación denegado.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de ubicación están permanentemente denegados.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rapidito!',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 32,
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Categorias2(
                                categoria: 'Licencias de conducir',
                              )));
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.building),
                title: const Text('Otras entidades'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Categorias2(
                                categoria: 'Otras entidades',
                              )));
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: <Widget>[
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
