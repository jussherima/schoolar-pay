import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/parent.dart';
import '../models/eleve.dart';
import '../models/paiement.dart';

class DatabaseService {
  static Database? _database;
  static final DatabaseService instance = DatabaseService._init();

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('schoolar_pay.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE parents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        prenom TEXT NOT NULL,
        cin TEXT NOT NULL UNIQUE,
        mot_de_passe TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE eleves (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        identifiant TEXT NOT NULL UNIQUE,
        nom TEXT NOT NULL,
        prenom TEXT NOT NULL,
        classe TEXT NOT NULL,
        frais_total REAL NOT NULL,
        frais_paye REAL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE paiements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parent_id INTEGER NOT NULL,
        eleve_id INTEGER NOT NULL,
        montant REAL NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (parent_id) REFERENCES parents (id),
        FOREIGN KEY (eleve_id) REFERENCES eleves (id)
      )
    ''');

    await _insertTestData(db);
  }

  Future<void> _insertTestData(Database db) async {
    final eleves = [
      {'identifiant': 'ELV001', 'nom': 'Rakoto', 'prenom': 'Jean', 'classe': '6ème', 'frais_total': 150000.0, 'frais_paye': 0.0},
      {'identifiant': 'ELV002', 'nom': 'Rasoa', 'prenom': 'Marie', 'classe': '5ème', 'frais_total': 150000.0, 'frais_paye': 50000.0},
      {'identifiant': 'ELV003', 'nom': 'Rabe', 'prenom': 'Paul', 'classe': '4ème', 'frais_total': 175000.0, 'frais_paye': 0.0},
      {'identifiant': 'ELV004', 'nom': 'Ravao', 'prenom': 'Lina', 'classe': '3ème', 'frais_total': 175000.0, 'frais_paye': 100000.0},
      {'identifiant': 'ELV005', 'nom': 'Randria', 'prenom': 'Hery', 'classe': 'Terminale', 'frais_total': 200000.0, 'frais_paye': 0.0},
    ];

    for (var eleve in eleves) {
      await db.insert('eleves', eleve);
    }
  }

  // Parent methods
  Future<int> insertParent(Parent parent) async {
    final db = await database;
    return await db.insert('parents', parent.toMap());
  }

  Future<Parent?> getParentByCin(String cin) async {
    final db = await database;
    final maps = await db.query(
      'parents',
      where: 'cin = ?',
      whereArgs: [cin],
    );

    if (maps.isNotEmpty) {
      return Parent.fromMap(maps.first);
    }
    return null;
  }

  Future<Parent?> login(String cin, String motDePasse) async {
    final db = await database;
    final maps = await db.query(
      'parents',
      where: 'cin = ? AND mot_de_passe = ?',
      whereArgs: [cin, motDePasse],
    );

    if (maps.isNotEmpty) {
      return Parent.fromMap(maps.first);
    }
    return null;
  }

  // Eleve methods
  Future<Eleve?> getEleveByIdentifiant(String identifiant) async {
    final db = await database;
    final maps = await db.query(
      'eleves',
      where: 'identifiant = ?',
      whereArgs: [identifiant],
    );

    if (maps.isNotEmpty) {
      return Eleve.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateFraisPaye(int eleveId, double nouveauMontant) async {
    final db = await database;
    await db.update(
      'eleves',
      {'frais_paye': nouveauMontant},
      where: 'id = ?',
      whereArgs: [eleveId],
    );
  }

  // Paiement methods
  Future<int> insertPaiement(Paiement paiement) async {
    final db = await database;
    return await db.insert('paiements', paiement.toMap());
  }

  Future<List<Paiement>> getPaiementsByParent(int parentId) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT p.*, e.nom as eleve_nom, e.prenom as eleve_prenom
      FROM paiements p
      JOIN eleves e ON p.eleve_id = e.id
      WHERE p.parent_id = ?
      ORDER BY p.date DESC
    ''', [parentId]);

    return maps.map((map) => Paiement.fromMap(map)).toList();
  }
}
