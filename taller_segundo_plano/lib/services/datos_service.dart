import 'package:flutter/foundation.dart';

/// Servicio simulado que "consulta" datos con Future.delayed.
class DatosService {
  Future<String> consultarDatos({bool fallar = false}) async {
    debugPrint('[Service] Iniciando consulta...');
    await Future.delayed(const Duration(seconds: 3));
    if (fallar) {
      throw Exception('Error simulado en el servidor');
    }
    debugPrint('[Service] Consulta terminada');
    return 'Datos recibidos correctamente';
  }
}
