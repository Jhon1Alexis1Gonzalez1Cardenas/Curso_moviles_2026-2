import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Acceso centralizado a las variables de entorno (archivo .env).
class Env {
  static const String _urlPorDefecto = 'https://api-colombia.com/api/v1';

  static String get baseUrl {
    final valor = dotenv.maybeGet('API_BASE_URL');
    final url = (valor == null || valor.trim().isEmpty) ? _urlPorDefecto : valor.trim();
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }
}
