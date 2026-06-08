// lib/screens/detail_screen.dart
// Écran 2 : Détail d'une observation — reçoit l'argument depuis l'écran 1

import 'package:flutter/material.dart';
import '../models/observation.dart';
import '../widgets/badge_protegee.dart';

class DetailScreen extends StatelessWidget {
  // L'observation est reçue comme argument via Navigator.pushNamed
  final Observation observation;
  final Function(String) onSupprimer;

  const DetailScreen({
    super.key,
    required this.observation,
    required this.onSupprimer,
  });

  String _formatDate(DateTime d) {
    const mois = [
      '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${d.day} ${mois[d.month]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F6),
      appBar: AppBar(
        title: const Text('Détail de l\'observation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Supprimer',
            onPressed: () => _confirmerSuppression(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête illustré
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A6B5C), Color(0xFF1A9F8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.water, color: Colors.white, size: 64),
                  const SizedBox(height: 12),
                  Text(
                    observation.espece,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  BadgeProtegee(
                    estProtegee: observation.especeProtegee,
                    grand: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Détails
            _Champ(
              icone: Icons.location_on,
              label: 'Zone marine',
              valeur: observation.zone,
            ),
            _Champ(
              icone: Icons.groups,
              label: 'Nombre observé',
              valeur: '${observation.nombreObserve} individu(s)',
            ),
            _Champ(
              icone: Icons.calendar_today,
              label: 'Date d\'observation',
              valeur: _formatDate(observation.date),
            ),
            _Champ(
              icone: Icons.shield,
              label: 'Statut de protection',
              valeur: observation.especeProtegee
                  ? '⚠️ Espèce protégée'
                  : '✅ Non protégée (surveillance normale)',
            ),

            const SizedBox(height: 24),

            // Infos sur la zone
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'À propos de la zone',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    observation.zone == 'Joal-Fadiouth'
                        ? 'Joal-Fadiouth est une aire marine protégée au Sénégal, '
                            'connue pour sa biodiversité aquatique et ses mangroves.'
                        : 'Bamboung est une aire marine communautaire protégée au Sénégal, '
                            'espace de réhabilitation des ressources halieutiques.',
                    style: const TextStyle(color: Colors.blueGrey, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmerSuppression(BuildContext context) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Supprimer l\'observation de "${observation.espece}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirme == true) {
      onSupprimer(observation.id);
      // Retour à la liste après suppression
      if (context.mounted) Navigator.pop(context);
    }
  }
}

// Widget Stateless réutilisable pour afficher un champ de détail
class _Champ extends StatelessWidget {
  final IconData icone;
  final String label;
  final String valeur;

  const _Champ({
    required this.icone,
    required this.label,
    required this.valeur,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icone, color: const Color(0xFF0A6B5C), size: 24),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                valeur,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
