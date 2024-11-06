import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sncappdcv/views/Editoriales/editorial1.dart';
import 'package:sncappdcv/views/Paginas/categorias2.dart';
import 'package:sncappdcv/views/Paginas/entidades2.dart';
import 'package:sncappdcv/views/Widgets/cards.dart';
import 'package:sncappdcv/views/Widgets/detentidad.dart';

class Inicio2 extends StatefulWidget {
  const Inicio2({super.key});

  @override
  State<Inicio2> createState() => _Inicio2State();
}

class _Inicio2State extends State<Inicio2> {
  int _indicePagina = 0;
  final PageController _pageController = PageController();
  EntidadesCard EntDestacada = const EntidadesCard(
    nomimagen: 'ecsal_1.jpg',
    razonsocial: 'Brevetes Salud S.A.C',
    direccion: 'Jr. Antenor Orrego 1978',
    categoria: 'Licencias de conducir',
    precio: 24.00,
    calificacion: 5,
    estado: 'CON AUTORIZACION',
    proximidad: 0.08,
    coordenadas: LatLng(-12.058227, -77.060768),
  );
  //late List<EntidadesCard> _entCercanas;
  final FocusNode _focusNode = FocusNode();
  LatLng posicionActual = const LatLng(0.0, 0.0);

  List<String> entidades = [
    'Centro Médico Lima',
    'Escuela de Conductores Arequipa',
    'Centro de Evaluación Cusco',
    'Centro de ITV Piura',
    'Taller de Conversión GNV/GLP Trujillo',
    'Certificadora GNV/GLP Tacna',
    'Entidad Verificadora Ica',
    'Centro de RPC Callao',
    'Entidad CVC Huancayo'
  ];

  List<String> entidadesFiltradas = [];
  bool _mostrandoResultados = false;

  final TextEditingController _buscarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _indicePagina = 0;
    entidadesFiltradas = entidades;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _removerFoco() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void _filtrarEntidades(String query) {
    List<String> resultados = [];

    if (query.isEmpty) {
      resultados = entidades;
      _mostrandoResultados = false;
    } else {
      resultados = entidades
          .where(
              (entidad) => entidad.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _mostrandoResultados = true;
    }

    setState(() {
      entidadesFiltradas = resultados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _removerFoco,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: TextField(
                controller: _buscarController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Buscar entidades...',
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: _filtrarEntidades,
              ),
            ),
            const SizedBox(height: 10),
            if (_mostrandoResultados)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entidadesFiltradas.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(entidadesFiltradas[index]),
                      onTap: () {
                        print('Seleccionaste ${entidadesFiltradas[index]}');
                      },
                    );
                  },
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
                        PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const Categorias2(
                                      categoria: '',
                                    ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = const Offset(1, 0);
                              var end = Offset.zero;

                              var tween = Tween(begin: begin, end: end);

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            }));
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
                        PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const Entidades2(
                                      categoria: '',
                                    ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = const Offset(1, 0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              var fadeTween = Tween(begin: 0.0, end: 1.0);

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: FadeTransition(
                                  opacity: animation.drive(fadeTween),
                                  child: child,
                                ),
                              );
                            }));
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
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const Editorial1(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1, 0);
                          var end = Offset.zero;

                          var tween = Tween(begin: begin, end: end);

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: FadeTransition(
                                opacity: animation, child: child),
                          );
                        },
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
                              'Cómo tramitar tu licencia de conducir electrónica',
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
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        Entidades2(
                                  categoria: category.entidad,
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
                                },
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
                    PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DetalleEnt(
                              imagen: EntDestacada.nomimagen,
                              razonsocial: EntDestacada.razonsocial,
                              direccion: EntDestacada.direccion,
                              categoria: EntDestacada.categoria,
                              precio: EntDestacada.precio,
                              calificacion: EntDestacada.calificacion,
                              estado: EntDestacada.estado,
                              proximidad: EntDestacada.proximidad,
                              coordenadas: EntDestacada.coordenadas,
                            ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1, 0);
                          var end = Offset.zero;

                          var tween = Tween(begin: begin, end: end);

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: FadeTransition(
                                opacity: animation, child: child),
                          );
                        }));
              },
            ),
            const SizedBox(height: 16),
            /*FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EntidadesView()));
                },
                child: const Icon(Icons.fork_right)),*/
          ],
        ),
      ),
    );
  }
}
