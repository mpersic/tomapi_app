class Skladista {
  factory Skladista.fromMap(Map<String, dynamic> map) {
    return Skladista(
      id: map['pj_uid'] ?? 0,
      name: map['naziv'] ?? '',
    );
  }

  Skladista({required this.id, required this.name});
  final String? id;
  final String? name;
}
