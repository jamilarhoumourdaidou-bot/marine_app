// lib/models/observation.dart

class Observation {
  final String id;
  String espece;
  String zone;
  int nombreObserve;
  DateTime date;
  bool especeProtegee;

  Observation({
    required this.id,
    required this.espece,
    required this.zone,
    required this.nombreObserve,
    required this.date,
    required this.especeProtegee,
  });

  // Copie avec modifications
  Observation copyWith({
    String? espece,
    String? zone,
    int? nombreObserve,
    DateTime? date,
    bool? especeProtegee,
  }) {
    return Observation(
      id: this.id,
      espece: espece ?? this.espece,
      zone: zone ?? this.zone,
      nombreObserve: nombreObserve ?? this.nombreObserve,
      date: date ?? this.date,
      especeProtegee: especeProtegee ?? this.especeProtegee,
    );
  }

  @override
  String toString() {
    return 'Observation(id: $id, espece: $espece, zone: $zone, '
        'nombreObserve: $nombreObserve, date: $date, especeProtegee: $especeProtegee)';
  }
}
