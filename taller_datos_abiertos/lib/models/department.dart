import 'item_api.dart';

/// Departamento de Colombia (endpoint /Department).
class Department implements ItemApi {
  @override
  final int id;
  final String name;
  @override
  final String descripcion;
  final String? capital;
  final int? municipalities;
  final int? surface;
  final int? population;
  final String? phonePrefix;

  const Department({
    required this.id,
    required this.name,
    required this.descripcion,
    this.capital,
    this.municipalities,
    this.surface,
    this.population,
    this.phonePrefix,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    final capitalJson = json['cityCapital'];
    return Department(
      id: (json['id'] as num).toInt(),
      name: (json['name'] ?? '') as String,
      descripcion: (json['description'] ?? '') as String,
      capital: capitalJson is Map<String, dynamic>
          ? capitalJson['name'] as String?
          : null,
      municipalities: (json['municipalities'] as num?)?.toInt(),
      surface: (json['surface'] as num?)?.toInt(),
      population: (json['population'] as num?)?.toInt(),
      phonePrefix: json['phonePrefix']?.toString(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': descripcion,
        'cityCapital': {'name': capital},
        'municipalities': municipalities,
        'surface': surface,
        'population': population,
        'phonePrefix': phonePrefix,
      };

  @override
  String get titulo => name;

  @override
  String? get subtitulo => capital == null ? null : 'Capital: $capital';

  @override
  String? get imagen => null;

  @override
  Map<String, String> get datos => {
        'Capital': textoOGuion(capital),
        'Municipios': formatoNumero(municipalities),
        'Superficie': '${formatoNumero(surface)} km²',
        'Población': formatoNumero(population),
        'Prefijo telefónico': textoOGuion(phonePrefix),
      };
}
