import 'package:flutter/material.dart';
import '../models/parent.dart';
import '../models/eleve.dart';
import '../services/database_service.dart';
import 'paiement_screen.dart';
import 'historique_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final Parent parent;

  const HomeScreen({super.key, required this.parent});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _identifiantController = TextEditingController();
  Eleve? _eleve;
  bool _isSearching = false;
  String? _errorMessage;

  @override
  void dispose() {
    _identifiantController.dispose();
    super.dispose();
  }

  Future<void> _rechercherEleve() async {
    if (_identifiantController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez entrer un identifiant';
        _eleve = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      final eleve = await DatabaseService.instance.getEleveByIdentifiant(
        _identifiantController.text.toUpperCase(),
      );

      setState(() {
        _eleve = eleve;
        if (eleve == null) {
          _errorMessage = 'Aucun élève trouvé avec cet identifiant';
        }
      });
    } finally {
      setState(() => _isSearching = false);
    }
  }

  void _allerAuPaiement() {
    if (_eleve != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaiementScreen(
            parent: widget.parent,
            eleve: _eleve!,
          ),
        ),
      ).then((_) {
        _rechercherEleve();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schoolar Pay'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoriqueScreen(parent: widget.parent),
                ),
              );
            },
            tooltip: 'Historique',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.person, size: 50, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.parent.prenom} ${widget.parent.nom}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'CIN: ${widget.parent.cin}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Rechercher un élève',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _identifiantController,
                    decoration: const InputDecoration(
                      labelText: 'Identifiant de l\'élève',
                      hintText: 'Ex: ELV001',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    onSubmitted: (_) => _rechercherEleve(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isSearching ? null : _rechercherEleve,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  ),
                  child: _isSearching
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                ),
              ],
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
            if (_eleve != null) ...[
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.school, size: 40, color: Colors.green),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_eleve!.prenom} ${_eleve!.nom}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'ID: ${_eleve!.identifiant}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _buildInfoRow('Classe', _eleve!.classe),
                      _buildInfoRow('Frais total', '${_eleve!.fraisTotal.toStringAsFixed(0)} Ar'),
                      _buildInfoRow('Déjà payé', '${_eleve!.fraisPaye.toStringAsFixed(0)} Ar'),
                      _buildInfoRow(
                        'Reste à payer',
                        '${_eleve!.fraisRestant.toStringAsFixed(0)} Ar',
                        valueColor: _eleve!.fraisRestant > 0 ? Colors.red : Colors.green,
                      ),
                      const SizedBox(height: 16),
                      if (_eleve!.fraisRestant > 0)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _allerAuPaiement,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Payer',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        )
                      else
                        const Center(
                          child: Text(
                            'Frais de scolarité entièrement payés',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
