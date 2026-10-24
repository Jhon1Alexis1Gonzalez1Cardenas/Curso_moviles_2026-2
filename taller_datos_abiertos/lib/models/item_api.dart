/// Contrato común de todos los modelos de API Colombia.
///
/// Permite que el Listado y el Detalle sean genéricos: cada modelo sabe
/// presentarse (título, subtítulo, imagen, descripción y datos clave).
abstract class ItemApi {
  int get id;
  String get titulo;
  String? get subtitulo;
  String? get imagen;
  String get descripcion;

  /// Pares etiqueta -> valor que se muestran en la pantalla de detalle.
  Map<String, String> get datos;

  Map<String, dynamic> toJson();
}

/// 4589278 -> "4.589.278". Devuelve "—" si el valor es nulo.
String formatoNumero(num? n) {
  if (n == null) return '—';
  final s = n.toInt().toString();
  return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
}

/// Devuelve el texto o "—" si es nulo o vacío.
String textoOGuion(String? s) {
  if (s == null || s.trim().isEmpty) return '—';
  return s.trim();
}
