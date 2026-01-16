# Donnees de test - Schoolar Pay

Ce document liste les donnees de test pre-enregistrees dans l'application.

## Eleves disponibles

L'application contient 5 eleves de test pour faciliter les demonstrations et les tests.

| Identifiant | Nom | Prenom | Classe | Frais Total (Ar) | Deja Paye (Ar) | Reste a Payer (Ar) |
|-------------|-----|--------|--------|------------------|----------------|---------------------|
| `ELV001` | Rakoto | Jean | 6eme | 150 000 | 0 | 150 000 |
| `ELV002` | Rasoa | Marie | 5eme | 150 000 | 50 000 | 100 000 |
| `ELV003` | Rabe | Paul | 4eme | 175 000 | 0 | 175 000 |
| `ELV004` | Ravao | Lina | 3eme | 175 000 | 100 000 | 75 000 |
| `ELV005` | Randria | Hery | Terminale | 200 000 | 0 | 200 000 |

## Utilisation

1. **Inscription** : Creez un compte parent avec vos informations (nom, prenom, CIN, mot de passe)
2. **Connexion** : Connectez-vous avec votre CIN et mot de passe
3. **Recherche** : Entrez l'identifiant d'un eleve (ex: `ELV001`) pour voir ses informations
4. **Paiement** : Cliquez sur "Payer" et entrez le montant a payer
5. **Historique** : Consultez vos paiements effectues via l'icone historique

## Structure de la base de donnees

### Table `parents`
| Colonne | Type | Description |
|---------|------|-------------|
| id | INTEGER | Identifiant unique (auto-increment) |
| nom | TEXT | Nom du parent |
| prenom | TEXT | Prenom du parent |
| cin | TEXT | Numero CIN (unique) |
| mot_de_passe | TEXT | Mot de passe |

### Table `eleves`
| Colonne | Type | Description |
|---------|------|-------------|
| id | INTEGER | Identifiant unique (auto-increment) |
| identifiant | TEXT | Identifiant scolaire (unique, ex: ELV001) |
| nom | TEXT | Nom de l'eleve |
| prenom | TEXT | Prenom de l'eleve |
| classe | TEXT | Classe de l'eleve |
| frais_total | REAL | Montant total des frais de scolarite |
| frais_paye | REAL | Montant deja paye |

### Table `paiements`
| Colonne | Type | Description |
|---------|------|-------------|
| id | INTEGER | Identifiant unique (auto-increment) |
| parent_id | INTEGER | Reference vers le parent |
| eleve_id | INTEGER | Reference vers l'eleve |
| montant | REAL | Montant du paiement |
| date | TEXT | Date et heure du paiement (ISO 8601) |

## Notes

- Les donnees sont stockees localement sur l'appareil avec SQFlite
- Les eleves de test sont crees automatiquement au premier lancement
- Le solde des parents est infini (simulation de paiement)
- Les paiements sont enregistres en temps reel dans l'historique
