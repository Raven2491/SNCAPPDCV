import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sncappdcv/ViewModels/entidad_vm.dart';
import 'package:sncappdcv/Views/Paginas/categorias.dart';
import 'package:sncappdcv/Views/Paginas/categorias2.dart';
import 'package:sncappdcv/Views/Paginas/entidades3.dart';
import 'package:sncappdcv/Views/Paginas/favoritos.dart';
import 'package:sncappdcv/Views/Paginas/inicio.dart';
import 'package:sncappdcv/Views/Paginas/mapaentidades2.dart';

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
    return ChangeNotifierProvider(
      create: (context) => EntidadViewModel()..cargarEntidades(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        home: const PantallaCarga(),
      ),
    );
  }
}

class PantallaCarga extends StatefulWidget {
  const PantallaCarga({super.key});

  @override
  State<PantallaCarga> createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga> {
  LatLng? posicionActual;

  @override
  void initState() {
    super.initState();
    _obtenerUbicacion();
  }

  Future<void> _obtenerUbicacion() async {
    try {
      Position position = await _determinarPosicion();
      setState(() {
        posicionActual = LatLng(position.latitude, position.longitude);
      });
      _navegarAPantallaPrincipal();
    } catch (e) {
      print('Error al obtener la ubicación: $e');
      if (e.toString() != 'El servicio de ubicación está deshabilitado.') {
        _mostrarDialogoError();
      }
    }
  }

  Future<Position> _determinarPosicion() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      bool habilitarGPS = await _mostrarDialogoHabilitarGPS();
      if (habilitarGPS) {
        await Geolocator.openLocationSettings();
        // Espera un momento para que el usuario habilite el GPS
        await Future.delayed(const Duration(seconds: 5));
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          return Future.error('El servicio de ubicación está deshabilitado.');
        }
      } else {
        SystemNavigator.pop();
      }
    }

    // Verifica y solicita permisos de ubicación
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

    // Obtiene la posición actual del dispositivo
    return await Geolocator.getCurrentPosition();
  }

  Future<bool> _mostrarDialogoHabilitarGPS() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Habilitar GPS'),
              content:
                  const Text('El GPS está deshabilitado. ¿Desea habilitarlo?'),
              actions: [
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Sí'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _navegarAPantallaPrincipal() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SNCAPP(posicionActual: posicionActual!),
      ),
    );
  }

  void _mostrarDialogoError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('No se pudo obtener la ubicación.'),
          actions: [
            TextButton(
              child: const Text('Reintentar'),
              onPressed: () {
                Navigator.of(context).pop();
                _obtenerUbicacion();
              },
            ),
          ],
        );
      },
    );
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
  final LatLng posicionActual;
  const SNCAPP({super.key, required this.posicionActual});

  @override
  State<SNCAPP> createState() => _SNCAPPState();
}

class _SNCAPPState extends State<SNCAPP> {
  int _indiceBselec = 2;

  late List<Widget> _paginas;

  @override
  void initState() {
    super.initState();
    _paginas = [
      const PaginaFavoritos(),
      /*MapaEntidades(
        posicionActual: widget.posicionActual,
      ),*/
      MapaEntidades2(posicionActual: widget.posicionActual),
      const Inicio2(),
      const Categorias(categoria: ''),
      /*const Entidades(
        categoria: 'Todas',
      ),*/
      const Entidades3(
        categoria: 'Todas',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Rapidito!',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 32,
                          fontWeight: FontWeight.bold))
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .scale(),
              const Text(
                '¡Tus entidades a un toque y al toque!',
                style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
              ).animate().fadeIn(duration: 800.ms, delay: 500.ms).scale(),
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
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(children: [Expanded(child: child)])),
            );
          },
          child: _paginas[_indiceBselec],
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
          ),
        ),
      ),
    );
  }
}
