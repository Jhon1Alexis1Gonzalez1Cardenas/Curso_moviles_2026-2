import 'item_api.dart';

/// Plato típico de Colombia (endpoint /TypicalDish).
class TypicalDish implements ItemApi {
  @override
  final int id;
  final String name;
  @override
  final String descripcion;
  final String? ingredients;
  final String? imageUrl;
  final int? departmentId;
  final String? departmentName;

  const TypicalDish({
    required this.id,
    required this.name,
    required this.descripcion,
    this.ingredients,
    this.imageUrl,
    this.departmentId,
    this.departmentName,
  });

  factory TypicalDish.fromJson(Map<String, dynamic> json) {
    final dep = json['department'];
    return TypicalDish(
      id: (json['id'] as num).toInt(),
      name: (json['name'] ?? '') as String,
      descripcion: ((json['description'] ?? '') as String).trim(),
      ingredients: json['ingredients'] as String?,
      imageUrl: json['imageUrl'] as String?,
      departmentId: (json['departmentId'] as num?)?.toInt(),
      departmentName: dep is Map<String, dynamic> ? dep['name'] as String? : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': descripcion,
        'ingredients': ingredients,
        'imageUrl': imageUrl,
        'departmentId': departmentId,
        'department': {'name': departmentName},
      };

  @override
  String get titulo => name;

  @override
  String? get subtitulo => departmentName;

  @override
  String? get imagen => imageUrl;

  @override
  Map<String, String> get datos => {
        'Departamento': textoOGuion(departmentName),
        'Ingredientes': textoOGuion(ingredients),
      };
}
