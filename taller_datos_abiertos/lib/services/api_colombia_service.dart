import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/api_endpoint.dart';
import '../config/env.dart';
import '../models/item_api.dart';

/// Error controlado de la capa de servicios, con mensaje apto para el usuario.
class ApiException implements Exception {
  final String mensaje;
  final int? statusCode;

  const ApiException(this.mensaje, {this.statusCode});

  @override
  String toString() => mensaje;
}

/// Toda la lógica HTTP de la app vive aquí (las vistas no conocen `http`).
class ApiColombiaService {
  ApiColombiaService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 20);

  /// GET /{endpoint}  ->  lista de registros.
  Future<List<ItemApi>> obtenerLista(ApiEndpoint endpoint) async {
    final cuerpo = await _get(endpoint.path);
    if (cuerpo is! List) {
      throw const ApiException('La respuesta del servidor no tiene el formato esperado.');
    }
    return cuerpo
        .whereType<Map<String, dynamic>>()
        .map(endpoint.parse)
        .toList();
  }

  /// GET /{endpoint}/{id}  ->  un registro.
  Future<ItemApi> obtenerPorId(ApiEndpoint endpoint, int id) async {
    final cuerpo = await _get('${endpoint.path}/$id');
    if (cuerpo is! Map<String, dynamic>) {
      throw const ApiException('La respuesta del servidor no tiene el formato esperado.');
    }
    return endpoint.parse(cuerpo);
  }

  Future<dynamic> _get(String ruta) async {
    final uri = Uri.parse('${Env.baseUrl}/$ruta');
    debugPrint('[API] GET $uri');
    try {
      final respuesta = await _client
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(_timeout);
      debugPrint('[API] <- ${respuesta.statusCode}');

      final codigo = respuesta.statusCode;
      if (codigo == 200) {
        return jsonDecode(utf8.decode(respuesta.bodyBytes));
      }
      if (codigo == 404) {
        throw ApiException('No se encontró el recurso solicitado (404).', statusCode: codigo);
      }
      if (codigo >= 500) {
        throw ApiException('El servidor tuvo un problema ($codigo). Intenta más tarde.',
            statusCode: codigo);
      }
      throw ApiException('Error inesperado en la petición ($codigo).', statusCode: codigo);
    } on TimeoutException {
      throw const ApiException('Tiempo de espera agotado. Revisa tu conexión.');
    } on http.ClientException {
      throw const ApiException('No se pudo conectar con el servidor. Revisa tu conexión.');
    } on FormatException {
      throw const ApiException('La respuesta del servidor no es válida.');
    }
  }
}
