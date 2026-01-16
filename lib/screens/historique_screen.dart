import 'package:flutter/material.dart';
import '../models/parent.dart';
import '../models/paiement.dart';
import '../services/database_service.dart';

class HistoriqueScreen extends StatefulWidget {
  final Parent parent;

  const HistoriqueScreen({super.key, required this.parent});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  List<Paiement> _paiements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerPaiements();
  }

  Future<void> _chargerPaiements() async {
    setState(() => _isLoading = true);
    try {
      final paiements = await DatabaseService.instance.getPaiementsByParent(widget.parent.id!);
      setState(() => _paiements = paiements);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des paiements'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _paiements.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Aucun paiement effectué',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _chargerPaiements,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _paiements.length,
                    itemBuilder: (context, index) {
                      final paiement = _paiements[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.check, color: Colors.white),
                          ),
                          title: Text(
                            '${paiement.elevePrenom ?? ''} ${paiement.eleveNom ?? ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(_formatDate(paiement.date)),
                          trailing: Text(
                            '${paiement.montant.toStringAsFixed(0)} Ar',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
