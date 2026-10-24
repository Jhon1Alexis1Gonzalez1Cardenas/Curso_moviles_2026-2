import 'item_api.dart';

/// Atractivo turístico de Colombia (endpoint /TouristicAttraction).
class TouristicAttraction implements ItemApi {
  @override
  final int id;
  final String name;
  @override
  final String descripcion;
  final List<String> images;
  final String? latitude;
  final String? longitude;
  final int? cityId;
  final String? cityName;

  const TouristicAttraction({
    required this.id,
    required this.name,
    required this.descripcion,
    this.images = const [],
    this.latitude,
    this.longitude,
    this.cityId,
    this.cityName,
  });

  factory TouristicAttraction.fromJson(Map<String, dynamic> json) {
    final city = json['city'];
    final imgs = json['images'];
    return TouristicAttraction(
      id: (json['id'] as num).toInt(),
      name: ((json['name'] ?? '') as String).trim(),
      descripcion: (json['description'] ?? '') as String,
      images: imgs is List ? imgs.map((e) => e.toString()).toList() : const [],
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      cityId: (json['cityId'] as num?)?.toInt(),
      cityName: city is Map<String, dynamic> ? city['name'] as String? : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': descripcion,
        'images': images,
        'latitude': latitude,
        'longitude': longitude,
        'cityId': cityId,
        'city': {'name': cityName},
      };

  @override
  String get titulo => name;

  @override
  String? get subtitulo => cityName;

  /// Primera imagen que sea una URL válida (algunos registros traen texto suelto).
  @override
  String? get imagen {
    for (final img in images) {
      if (img.trim().toLowerCase().startsWith('http')) return img;
    }
    return null;
  }

  @override
  Map<String, String> get datos => {
        'Ciudad': textoOGuion(cityName),
        'Latitud': textoOGuion(latitude),
        'Longitud': textoOGuion(longitude),
      };
}
