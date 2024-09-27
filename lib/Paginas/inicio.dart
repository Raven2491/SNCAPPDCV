import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sncappdcv/Editoriales/editorial1.dart';
import 'package:sncappdcv/Paginas/categorias2.dart';
import 'package:sncappdcv/Paginas/entidades.dart';
import 'package:sncappdcv/Paginas/entidades2.dart';
import 'package:sncappdcv/Widgets/cards.dart';
import 'package:sncappdcv/Widgets/detentidad.dart';
/*import 'package:sncappdcv/Paginas/categorias.dart';
import 'package:sncappdcv/Paginas/entidades.dart';
import 'package:sncappdcv/Widgets/detentidad.dart';*/

class Inicio2 extends StatefulWidget {
  const Inicio2({super.key});

  @override
  State<Inicio2> createState() => _Inicio2State();
}

class _Inicio2State extends State<Inicio2> {
  final int _indiceBselec = 2;
  int _indicePagina = 0;
  final PageController _pageController = PageController();
  final FocusNode _focusNode = FocusNode();
  EntidadesCard EntDestacada = EntidadesCard(
    imagen: Image.asset('assets/images/ecsal_1.jpg'),
    razonsocial: 'Brevetes Salud S.A.C',
    direccion: 'Jr. Antenor Orrego 1978',
    categoria: 'Licencias de conducir',
    precio: 24.00,
    calificacion: 5,
    estado: 'Con autorización',
    proximidad: 0.08,
  );
  late List<EntidadesCard> _entCercanas;
  late Position _posActual;

  @override
  void initState() {
    super.initState();
    _indicePagina = 0; // Reiniciar el índice en 0
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _removerFocus() {
    _focusNode.unfocus();
  }

  Future<Position> _determinarPosicion() async {
    LocationPermission permiso;
    permiso = await Geolocator.requestPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        return Future.error('Permiso de ubicación denegado');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void _obtenerUbicacion() async {
    _posActual = await _determinarPosicion();
    print('Ubicación actual: ${_posActual.latitude}, ${_posActual.longitude}');
  }

  void _obtenerEntCercanas() async {
    _posActual = await _determinarPosicion();

    // Obtener todas? las entidades con la API y almacenar en una lista

    // Calcular la distancia entre la ubicación actual y las entidades de la lista

    // Ordenar la lista de entidades por proximidad

    // Guardar en la lista _entCercanas aquellas entidades cuya distancia sea menor a 15 km

    // Seleccionar de la lista la entidad con la proximidad menor y asignarla a EntDestacada
  }

  void _obtenerEntidadDestacada() async {
    Position posicion = await _determinarPosicion();

    // Cálculo de distancia entre dos puntos
    double distancia = Geolocator.distanceBetween(
        posicion.latitude, posicion.longitude, -12.058242, -77.060791);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _removerFocus,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: TextField(
              focusNode: _focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'Buscar entidades...',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _indicePagina = 0;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      'Inicio',
                      style: TextStyle(
                        fontSize: 16,
                        color: _indicePagina == 0
                            ? Colors.black
                            : Colors.grey.shade700,
                        fontWeight: _indicePagina == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (_indicePagina == 0)
                      Container(
                        height: 2,
                        width: 50,
                        color: Colors.red,
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _indicePagina = 1;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Categorias2(
                                categoria: '',
                              )));
                },
                child: Text(
                  'Categorias',
                  style: TextStyle(
                    fontSize: 16,
                    color: _indicePagina == 1
                        ? Colors.black
                        : Colors.grey.shade700,
                    fontWeight: _indicePagina == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _indicePagina = 2;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EntidadesFiltradas2(
                                categoria: '',
                              )));
                },
                child: Text(
                  'Entidades',
                  style: TextStyle(
                    fontSize: 16,
                    color: _indicePagina == 2
                        ? Colors.black
                        : Colors.grey.shade700,
                    fontWeight: _indicePagina == 2
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: PageView(
              controller: _pageController,
              children: [
                'assets/images/nuevalic.jpg',
                'assets/images/nuevalic.jpg',
                'assets/images/nuevalic.jpg',
              ].map((imagenPath) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Editorial1(),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 2.0, vertical: 5),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.7),
                                BlendMode.darken),
                            child: Image.asset(
                              imagenPath,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          right: 10,
                          child: Text(
                            'Cómo tramitar tu licencia electrónica',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.black.withOpacity(0.2),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Positioned(
                          top: 30,
                          left: 10,
                          right: 10,
                          child: Text(
                            'En esta nota te explicamos los pasos para obtener la licencia de conducir electrónica desde tu casa o trabajo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              backgroundColor: Colors.black.withOpacity(0.2),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: const SlideEffect(
              dotColor: Colors.grey,
              activeDotColor: Colors.red,
              dotHeight: 8,
              dotWidth: 8,
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Categorías populares',
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 102,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  enlargeCenterPage: true,
                  viewportFraction: 0.55,
                ),
                items: [
                  CategoriaCard(
                    imagen: Image.asset('assets/images/CITV.jpg'),
                    entidad: 'Centros de ITV',
                    tipo: 'Otras entidades',
                    cantidad: '+150 centros',
                    views: 1200,
                  ),
                  CategoriaCard(
                    imagen: Image.asset('assets/images/ecsal.jpg'),
                    entidad: 'Centros médicos',
                    tipo: 'Licencia',
                    cantidad: '+150 centros',
                    views: 1200,
                  ),
                  CategoriaCard(
                    imagen: Image.asset('assets/images/cent_eval.jpg'),
                    entidad: 'Centros de evaluación',
                    tipo: 'Licencias',
                    cantidad: '+100 centros',
                    views: 1200,
                  ),
                  CategoriaCard(
                    imagen: Image.asset('assets/images/esc_cond.jpg'),
                    entidad: 'Escuelas de conductores',
                    tipo: 'Licencias',
                    cantidad: '+20 centros',
                    views: 1200,
                  ),
                ].map((category) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EntidadesFiltradas2(
                                categoria: category.entidad,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: category,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Entidades destacadas',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto'),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            child: EntDestacada,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetalleEnt(
                            razonsocial: EntDestacada.razonsocial,
                            direccion: EntDestacada.direccion,
                            categoria: EntDestacada.categoria,
                            precio: EntDestacada.precio,
                            calificacion: EntDestacada.calificacion,
                            estado: EntDestacada.estado,
                            proximidad: EntDestacada.proximidad,
                          )));
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}