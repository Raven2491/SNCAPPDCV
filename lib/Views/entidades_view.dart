import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sncappdcv/ViewModels/entidad_vm.dart';

class EntidadesView extends StatelessWidget {
  const EntidadesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entidades'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(FontAwesomeIcons.arrowDownShortWide),
            onSelected: (String value) {
              Provider.of<EntidadViewModel>(context, listen: false)
                  .setFiltroSeleccionado(value);
              Provider.of<EntidadViewModel>(context, listen: false)
                  .filtrarYOrdenarEntidades('');
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
        ],
      ),
      body: Consumer<EntidadViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.entidades.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Buscar',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        Provider.of<EntidadViewModel>(context, listen: false)
                            .filtrarYOrdenarEntidades('');
                      },
                    ),
                  ),
                  onChanged: (query) {
                    Provider.of<EntidadViewModel>(context, listen: false)
                        .filtrarYOrdenarEntidades(query);
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.entidades.length,
                  itemBuilder: (context, index) {
                    final entidad = viewModel.entidades[index];
                    return Card(
                      child: ListTile(
                        leading: Image.asset('assets/images/${entidad.imagen}'),
                        title: Text(entidad.razonsocial),
                        subtitle: Text(entidad.direccion),
                        onTap: () {
                          // Navegar a la página de detalles de la entidad
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
