import 'package:flutter/material.dart';
import '../models/parent.dart';
import '../models/eleve.dart';
import '../models/paiement.dart';
import '../services/database_service.dart';

class PaiementScreen extends StatefulWidget {
  final Parent parent;
  final Eleve eleve;

  const PaiementScreen({
    super.key,
    required this.parent,
    required this.eleve,
  });

  @override
  State<PaiementScreen> createState() => _PaiementScreenState();
}

class _PaiementScreenState extends State<PaiementScreen> {
  final _montantController = TextEditingController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _montantController.text = widget.eleve.fraisRestant.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _montantController.dispose();
    super.dispose();
  }

  Future<void> _effectuerPaiement() async {
    final montant = double.tryParse(_montantController.text);
    if (montant == null || montant <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un montant valide')),
      );
      return;
    }

    if (montant > widget.eleve.fraisRestant) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le montant dépasse le reste à payer')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final paiement = Paiement(
        parentId: widget.parent.id!,
        eleveId: widget.eleve.id!,
        montant: montant,
        date: DateTime.now(),
      );

      await DatabaseService.instance.insertPaiement(paiement);

      final nouveauMontantPaye = widget.eleve.fraisPaye + montant;
      await DatabaseService.instance.updateFraisPaye(widget.eleve.id!, nouveauMontantPaye);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 30),
                SizedBox(width: 8),
                Text('Paiement réussi'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Élève: ${widget.eleve.prenom} ${widget.eleve.nom}'),
                Text('Montant payé: ${montant.toStringAsFixed(0)} Ar'),
                const SizedBox(height: 8),
                const Text(
                  'Merci pour votre paiement !',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement'),
        centerTitle: true,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations de l\'élève',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.school, size: 50, color: Colors.blue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.eleve.prenom} ${widget.eleve.nom}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Classe: ${widget.eleve.classe}'),
                              Text('ID: ${widget.eleve.identifiant}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Détails du paiement',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Frais total', '${widget.eleve.fraisTotal.toStringAsFixed(0)} Ar'),
                    _buildDetailRow('Déjà payé', '${widget.eleve.fraisPaye.toStringAsFixed(0)} Ar'),
                    const Divider(),
                    _buildDetailRow(
                      'Reste à payer',
                      '${widget.eleve.fraisRestant.toStringAsFixed(0)} Ar',
                      isBold: true,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Montant à payer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _montantController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                suffixText: 'Ar',
                hintText: 'Entrez le montant',
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildQuickAmountButton(50000),
                _buildQuickAmountButton(100000),
                _buildQuickAmountButton(widget.eleve.fraisRestant, label: 'Tout payer'),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isProcessing ? null : _effectuerPaiement,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: _isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Payer',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAmountButton(double amount, {String? label}) {
    return OutlinedButton(
      onPressed: () {
        _montantController.text = amount.toStringAsFixed(0);
      },
      child: Text(label ?? '${amount.toStringAsFixed(0)} Ar'),
    );
  }
}
