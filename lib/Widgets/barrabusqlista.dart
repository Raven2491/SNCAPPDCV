import 'package:flutter/material.dart';

class BusquedaLista extends SearchDelegate<String> {
  final List<String> entidades;

  // Constructor para pasar la lista de entidades
  BusquedaLista({required this.entidades});

  // Método que muestra las sugerencias mientras el usuario escribe
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> sugerencias = query.isEmpty
        ? entidades // Si el campo de búsqueda está vacío, muestra todas las entidades
        : entidades
            .where((entidad) =>
                entidad.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: sugerencias.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(sugerencias[index]),
          onTap: () {
            query = sugerencias[index];
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
    List<String> results = entidades
        .where((entidad) => entidad.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
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
