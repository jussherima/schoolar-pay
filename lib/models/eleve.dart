class Eleve {
  final int? id;
  final String identifiant;
  final String nom;
  final String prenom;
  final String classe;
  final double fraisTotal;
  final double fraisPaye;

  Eleve({
    this.id,
    required this.identifiant,
    required this.nom,
    required this.prenom,
    required this.classe,
    required this.fraisTotal,
    this.fraisPaye = 0,
  });

  double get fraisRestant => fraisTotal - fraisPaye;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'identifiant': identifiant,
      'nom': nom,
      'prenom': prenom,
      'classe': classe,
      'frais_total': fraisTotal,
      'frais_paye': fraisPaye,
    };
  }

  factory Eleve.fromMap(Map<String, dynamic> map) {
    return Eleve(
      id: map['id'],
      identifiant: map['identifiant'],
      nom: map['nom'],
      prenom: map['prenom'],
      classe: map['classe'],
      fraisTotal: map['frais_total'],
      fraisPaye: map['frais_paye'],
    );
  }
}
