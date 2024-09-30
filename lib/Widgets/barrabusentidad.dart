import 'package:flutter/material.dart';
import 'package:sncappdcv/Widgets/cards.dart';

class BusquedaEntidades extends SearchDelegate<String> {
  final List<EntidadesCard> entidades;

  // Constructor para pasar la lista de entidades
  BusquedaEntidades({required this.entidades});

  // Método que muestra las sugerencias mientras el usuario escribe
  @override
  Widget buildSuggestions(BuildContext context) {
    List<EntidadesCard> sugerencias = query.isEmpty
        ? entidades // Si el campo de búsqueda está vacío, muestra todas las entidades
        : entidades
            .where((entidad) =>
                entidad.razonsocial.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: sugerencias.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(sugerencias[index].razonsocial),
          onTap: () {
            query = sugerencias[index].razonsocial;
            showResults(
                context); // Muestra los resultados al seleccionar una sugerencia
          },
        );
      },
    );
  }

  // Método que muestra los resultados de la búsqueda
  @override
  Widget buildResults(BuildContext context) {
    List<EntidadesCard> results = entidades
        .where((entidad) =>
            entidad.razonsocial.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].razonsocial),
        );
      },
    );
  }

  // Opcional: Widget que aparece a la izquierda de la barra de búsqueda (normalmente el ícono de 'back')
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Borra el campo de búsqueda
        },
      ),
    ];
  }

  // Opcional: Widget que aparece a la izquierda de la barra de búsqueda (normalmente el ícono de 'back')
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Cierra la búsqueda al presionar 'back'
      },
    );
  }
}
