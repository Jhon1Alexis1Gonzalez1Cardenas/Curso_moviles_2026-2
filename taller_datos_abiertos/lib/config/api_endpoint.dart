import 'package:flutter/material.dart';

import '../models/department.dart';
import '../models/item_api.dart';
import '../models/president.dart';
import '../models/touristic_attraction.dart';
import '../models/typical_dish.dart';

/// Endpoints de API Colombia usados por la app.
///
/// `name` (por ejemplo "departamentos") es el parámetro `:tipo` de las rutas.
enum ApiEndpoint {
  departamentos(
    path: 'Department',
    titulo: 'Departamentos',
    descripcion: 'Los 32 departamentos y su capital, población y superficie.',
    icono: Icons.map_outlined,
  ),
  presidentes(
    path: 'President',
    titulo: 'Presidentes',
    descripcion: 'Quiénes han gobernado Colombia y en qué periodos.',
    icono: Icons.account_balance_outlined,
  ),
  platosTipicos(
    path: 'TypicalDish',
    titulo: 'Platos típicos',
    descripcion: 'Gastronomía tradicional de cada región del país.',
    icono: Icons.restaurant_outlined,
  ),
  atractivos(
    path: 'TouristicAttraction',
    titulo: 'Atractivos turísticos',
    descripcion: 'Lugares imperdibles para conocer en Colombia.',
    icono: Icons.landscape_outlined,
  );

  const ApiEndpoint({
    required this.path,
    required this.titulo,
    required this.descripcion,
    required this.icono,
  });

  final String path;
  final String titulo;
  final String descripcion;
  final IconData icono;

  /// Convierte un objeto JSON del endpoint en su modelo.
  ItemApi parse(Map<String, dynamic> json) {
    switch (this) {
      case ApiEndpoint.departamentos:
        return Department.fromJson(json);
      case ApiEndpoint.presidentes:
        return President.fromJson(json);
      case ApiEndpoint.platosTipicos:
        return TypicalDish.fromJson(json);
      case ApiEndpoint.atractivos:
        return TouristicAttraction.fromJson(json);
    }
  }

  /// Busca un endpoint por el valor del parámetro de ruta. Null si no existe.
  static ApiEndpoint? desdeNombre(String? nombre) {
    for (final e in ApiEndpoint.values) {
      if (e.name == nombre) return e;
    }
    return null;
  }
}
