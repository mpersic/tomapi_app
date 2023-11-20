class Artikl {
  Artikl({required this.id, required this.name});

  factory Artikl.fromMap(Map<String, dynamic> map) {
    return Artikl(
      id: map['id'] ?? 0,
      name: map['naziv'] ?? '',
    );
  }
  final int? id;
  final String? name;
}
