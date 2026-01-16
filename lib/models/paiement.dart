class Paiement {
  final int? id;
  final int parentId;
  final int eleveId;
  final double montant;
  final DateTime date;
  final String? eleveNom;
  final String? elevePrenom;

  Paiement({
    this.id,
    required this.parentId,
    required this.eleveId,
    required this.montant,
    required this.date,
    this.eleveNom,
    this.elevePrenom,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parent_id': parentId,
      'eleve_id': eleveId,
      'montant': montant,
      'date': date.toIso8601String(),
    };
  }

  factory Paiement.fromMap(Map<String, dynamic> map) {
    return Paiement(
      id: map['id'],
      parentId: map['parent_id'],
      eleveId: map['eleve_id'],
      montant: map['montant'],
      date: DateTime.parse(map['date']),
      eleveNom: map['eleve_nom'],
      elevePrenom: map['eleve_prenom'],
    );
  }
}
