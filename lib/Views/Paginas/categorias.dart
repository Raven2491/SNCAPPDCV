import 'package:flutter/material.dart';
import 'package:sncappdcv/Views/Paginas/entidades2.dart';
import 'package:sncappdcv/Views/Widgets/cards.dart';

class Categorias extends StatefulWidget {
  final String categoria;

  const Categorias({super.key, required this.categoria});

  @override
  _CategoriasState createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  int _indiceFselec = 0;
  late List<CategoriaCard> categoriasFiltradas;
  late List<CategoriaCard> todasCategorias;

  List<CategoriaCard> categoriaBusqueda = [];
  bool _mostrandoResultados = false;
  final TextEditingController _buscarController = TextEditingController();

  void _onSegmentChanged(int index) {
    setState(() {
      _indiceFselec = index;
    });
  }

  final List<CategoriaCard> _Categorias = [
    CategoriaCard(
        imagen: Image.asset('assets/images/ecsal.jpg'),
        entidad: 'Centros médicos',
        tipo: 'Licencias de conducir',
        cantidad: '+150 centros',
        views: 1200),
    CategoriaCard(
        imagen: Image.asset('assets/images/esc_cond.jpg'),
        entidad: 'Escuelas de conductores',
        tipo: 'Licencias de conducir',
        cantidad: '+150 centros',
        views: 1200),
    CategoriaCard(
        imagen: Image.asset('assets/images/cent_eval.jpg'),
        entidad: 'Centros de evaluación',
        tipo: 'Licencias de conducir',
        cantidad: '+150 centros',
        views: 1200),
    CategoriaCard(
        imagen: Image.asset('assets/images/CITV.jpg'),
        entidad: 'Centros de ITV',
        tipo: 'Otras entidades',
        cantidad: '+150 centros',
        views: 1200),
    CategoriaCard(
        imagen: Image.asset('assets/images/gnv_glp.jpg'),
        entidad: 'Talleres de conversion GNV/GLP',
        tipo: 'Otras entidades',
        cantidad: '+150 centros',
        views: 1200),
    CategoriaCard(
        imagen: Image.asset('assets/images/certif_glp_gnv.png'),
        entidad: 'Certificadoras GNV/GLP',
        tipo: 'Otras entidades',
        cantidad: '+150 centros',
        views: 1200),
    CategoriaCard(
        imagen: Image.asset('assets/images/ecsal_1.jpg'),
        entidad: 'Entidad verificadora',
        tipo: 'Otras entidades',
        cantidad: '+150 centros',
        views: 1200),
    CategoriaCard(
        imagen: Image.asset('assets/images/rpc.jpg'),
        entidad: 'Centros de RPC',
        tipo: 'Otras entidades',
        cantidad: '+150 centros',
        views: 1200),
    CategoriaCard(
        imagen: Image.asset('assets/images/certif_glp_gnv.png'),
        entidad: 'Entidad CVC',
        tipo: 'Otras entidades',
        cantidad: '+150 centros',
        views: 1200)
  ];

  final List<String> opciones = [
    'Todas',
    'Licencias de conducir',
    'Otras entidades'
  ];

  @override
  void initState() {
    super.initState();
    _indiceFselec = opciones.indexWhere((opcion) => opcion == widget.categoria);
    if (_indiceFselec == -1) _indiceFselec = 0;
    todasCategorias = _Categorias;

    if (widget.categoria != 'Todas') {
      categoriasFiltradas =
          _Categorias.where((categoria) => categoria.tipo == widget.categoria)
              .toList();
    } else {
      categoriasFiltradas = _Categorias;
    }
  }

  void _filtrarEntidades(String query) {
    List<CategoriaCard> resultados;

    if (query.isEmpty) {
      resultados = todasCategorias;
      _mostrandoResultados = false;
    } else {
      resultados = todasCategorias
          .where((categoria) =>
              categoria.entidad.toLowerCase().contains(query.toLowerCase()) ||
              categoria.tipo.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _mostrandoResultados = true;
    }

    setState(() {
      categoriasFiltradas = resultados;
    });
  }

  List<CategoriaCard> aplicarFiltros() {
    List<CategoriaCard> filtradas = _indiceFselec == 0
        ? todasCategorias
        : todasCategorias
            .where((categoria) => categoria.tipo == opciones[_indiceFselec])
            .toList();

    return filtradas;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: TextField(
              controller: _buscarController,
              onChanged: _filtrarEntidades,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'Buscar entidades...',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          if (_mostrandoResultados)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categoriasFiltradas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(categoriasFiltradas[index].entidad),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Entidades2(
                            categoria: categoriasFiltradas[index].entidad,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(opciones.length, (indice) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _indiceFselec = indice;
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color:
                            _indiceFselec == indice ? Colors.red : Colors.white,
                        border: Border.all(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        opciones[indice],
                        style: TextStyle(
                            color: _indiceFselec == indice
                                ? Colors.white
                                : Colors.black,
                            fontSize: 13,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.normal),
                      )),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Categorías',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: aplicarFiltros().map((categoriaCard) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  Entidades2(categoria: categoriaCard.entidad),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = const Offset(1.0, 0.0);
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
                    child: categoriaCard,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
