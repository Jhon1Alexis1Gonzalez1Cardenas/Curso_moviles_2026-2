import 'item_api.dart';

/// Presidente de Colombia (endpoint /President).
class President implements ItemApi {
  @override
  final int id;
  final String name;
  final String lastName;
  final String? image;
  final String? startPeriodDate;
  final String? endPeriodDate;
  final String? politicalParty;
  @override
  final String descripcion;

  const President({
    required this.id,
    required this.name,
    required this.lastName,
    required this.descripcion,
    this.image,
    this.startPeriodDate,
    this.endPeriodDate,
    this.politicalParty,
  });

  factory President.fromJson(Map<String, dynamic> json) => President(
        id: (json['id'] as num).toInt(),
        name: (json['name'] ?? '') as String,
        lastName: (json['lastName'] ?? '') as String,
        descripcion: (json['description'] ?? '') as String,
        image: json['image'] as String?,
        startPeriodDate: json['startPeriodDate'] as String?,
        endPeriodDate: json['endPeriodDate'] as String?,
        politicalParty: json['politicalParty'] as String?,
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lastName': lastName,
        'description': descripcion,
        'image': image,
        'startPeriodDate': startPeriodDate,
        'endPeriodDate': endPeriodDate,
        'politicalParty': politicalParty,
      };

  static String? _anio(String? fecha) =>
      (fecha != null && fecha.length >= 4) ? fecha.substring(0, 4) : null;

  static String _fecha(String? fecha) =>
      (fecha != null && fecha.length >= 10) ? fecha.substring(0, 10) : '—';

  @override
  String get titulo => '$name $lastName'.trim();

  @override
  String? get subtitulo =>
      '${_anio(startPeriodDate) ?? '?'} – ${_anio(endPeriodDate) ?? 'actual'}';

  @override
  String? get imagen => image;

  @override
  Map<String, String> get datos => {
        'Partido político': textoOGuion(politicalParty),
        'Inicio del periodo': _fecha(startPeriodDate),
        'Fin del periodo':
            endPeriodDate == null ? 'En ejercicio' : _fecha(endPeriodDate),
      };
}
