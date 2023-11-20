class ObracunProizvoda {
  factory ObracunProizvoda.fromMap(Map<String, dynamic> map) {
    return ObracunProizvoda(
      id: map['artikl_uid'] ?? '',
      name: map['naziv_artikla'] ?? '',
      usluga: map['usluga'] ?? '',
      iznos: (map['iznos'] ?? 0).toDouble(),
      kolicina: (map['kolicina'] ?? 0).toDouble(),
    );
  }

  ObracunProizvoda(
      {required this.id,
      required this.kolicina,
      required this.name,
      required this.usluga,
      required this.iznos});
  final String? id;
  final String? name;
  final double? iznos;
  final double? kolicina;
  final String? usluga;
}
