import 'package:flutter/material.dart';
import 'package:sncappdcv/Paginas/entidades2.dart';
import 'package:sncappdcv/Widgets/cards.dart';
/*import 'package:sncappdcv/Paginas/entidades.dart';*/

class Categorias extends StatefulWidget {
  final String categoria; // Define the 'categoria' field

  const Categorias({super.key, required this.categoria});

  @override
  _CategoriasState createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  int _indiceFselec = 0;
  final FocusNode _focusNode = FocusNode();
  late List<CategoriaCard> categoriasFiltradas;
  late List<CategoriaCard> todasCategorias;

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

  @override
  void dispose() {
    _focusNode
        .dispose(); // Asegúrate de disponerlo para evitar fugas de memoria
    super.dispose();
  }

  void _removerFoco() {
    _focusNode.unfocus(); // Método para quitar el foco cuando sea necesario
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
      onTap: _removerFoco,
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
                        MaterialPageRoute(
                          builder: (context) => EntidadesFiltradas2(
                              categoria: categoriaCard.entidad),
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