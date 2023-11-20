class ObracunPlacanja {
  factory ObracunPlacanja.fromMap(Map<String, dynamic> map) {
    return ObracunPlacanja(
      id: map['vrste_placanja_uid'] ?? '',
      name: map['naziv'] ?? '',
      iznos: (map['iznos'] ?? 0).toDouble(),
    );
  }

  ObracunPlacanja({required this.id, required this.name, required this.iznos});
  final String? id;
  final String? name;
  final double? iznos;
}
