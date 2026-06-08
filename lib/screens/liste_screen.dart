// lib/screens/liste_screen.dart
// Écran 1 : Liste des observations avec filtre et compteur

import 'package:flutter/material.dart';
import '../models/observation.dart';
import '../widgets/badge_protegee.dart';
import '../widgets/compteur_protegees.dart';

class ListeScreen extends StatefulWidget {
  final List<Observation> observations;
  final Function(String) onSupprimer;

  const ListeScreen({
    super.key,
    required this.observations,
    required this.onSupprimer,
  });

  @override
  State<ListeScreen> createState() => _ListeScreenState();
}

class _ListeScreenState extends State<ListeScreen> {
  // État local : filtre "protégées seulement"
  bool _filtreProtegees = false;

  // Calcule la liste affichée selon le filtre
  List<Observation> get _observationsFiltrees {
    if (_filtreProtegees) {
      return widget.observations.where((o) => o.especeProtegee).toList();
    }
    return widget.observations;
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F6),
      appBar: AppBar(
        title: const Text('Aires Marines Protégées'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'À propos',
            onPressed: () => Navigator.pushNamed(context, '/apropos'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Compteur dynamique (Stateful)
          CompteurProtegees(observations: widget.observations),

          // Bouton filtre (Interaction dynamique - setState)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Text(
                  'Filtrer :',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(width: 12),
                FilterChip(
                  label: const Row(
                    children: [
                      Icon(Icons.shield, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Protégées uniquement',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  selected: _filtreProtegees,
                  onSelected: (val) {
                    // setState met à jour _filtreProtegees → rebuild de la liste
                    setState(() => _filtreProtegees = val);
                  },
                  selectedColor: const Color(0xFFD32F2F),
                  backgroundColor: const Color(0xFF0A6B5C),
                  checkmarkColor: Colors.white,
                  showCheckmark: false,
                ),
                const Spacer(),
                Text(
                  '${_observationsFiltrees.length} résultat(s)',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          // Liste des observations
          Expanded(
            child: _observationsFiltrees.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'Aucune observation trouvée',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _observationsFiltrees.length,
                    itemBuilder: (context, index) {
                      final obs = _observationsFiltrees[index];
                      return _CartObservation(
                        observation: obs,
                        onTap: () {
                          // Navigation vers Écran 2 (détail) avec passage d'argument
                          Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: obs, // Passage d'argument entre écrans
                          );
                        },
                        onSupprimer: () => _confirmerSuppression(context, obs),
                      );
                    },
                  ),
          ),
        ],
      ),
      // Bouton ajout → Écran 3 (formulaire)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/formulaire'),
        backgroundColor: const Color(0xFF0A6B5C),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle observation'),
      ),
    );
  }

  // Confirmation avant suppression (dialogue)
  Future<void> _confirmerSuppression(
      BuildContext context, Observation obs) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Supprimer l\'observation de "${obs.espece}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirme == true) {
      widget.onSupprimer(obs.id);
    }
  }
}

// Widget carte pour chaque observation dans la liste
class _CartObservation extends StatelessWidget {
  final Observation observation;
  final VoidCallback onTap;
  final VoidCallback onSupprimer;

  const _CartObservation({
    required this.observation,
    required this.onTap,
    required this.onSupprimer,
  });

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Icône zone
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A6B5C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.water,
                  color: Color(0xFF0A6B5C),
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            observation.espece,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        BadgeProtegee(estProtegee: observation.especeProtegee),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📍 ${observation.zone}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '${observation.nombreObserve} individu(s)',
                          style: const TextStyle(
                            color: Color(0xFF0A6B5C),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(observation.date),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Bouton supprimer
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: onSupprimer,
                tooltip: 'Supprimer',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
