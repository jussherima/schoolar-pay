class Parent {
  final int? id;
  final String nom;
  final String prenom;
  final String cin;
  final String motDePasse;

  Parent({
    this.id,
    required this.nom,
    required this.prenom,
    required this.cin,
    required this.motDePasse,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'cin': cin,
      'mot_de_passe': motDePasse,
    };
  }

  factory Parent.fromMap(Map<String, dynamic> map) {
    return Parent(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      cin: map['cin'],
      motDePasse: map['mot_de_passe'],
    );
  }
}
