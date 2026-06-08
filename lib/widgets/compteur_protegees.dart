// lib/widgets/compteur_protegees.dart

import 'package:flutter/material.dart';
import '../models/observation.dart';

/// Widget Stateful : compteur dynamique du nombre total d'espèces protégées observées.
/// setState est appelé chaque fois que la liste change (rebuild depuis le parent).
class CompteurProtegees extends StatefulWidget {
  final List<Observation> observations;

  const CompteurProtegees({super.key, required this.observations});

  @override
  State<CompteurProtegees> createState() => _CompteurProtegeesState();
}

class _CompteurProtegeesState extends State<CompteurProtegees>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  int _ancienTotal = 0;

  // Calcule le total des espèces protégées observées
  int get _totalProtegees {
    return widget.observations
        .where((o) => o.especeProtegee)
        .fold(0, (sum, o) => sum + o.nombreObserve);
  }

  @override
  void initState() {
    super.initState();
    _ancienTotal = _totalProtegees;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(CompteurProtegees oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si le total change, on anime le compteur
    if (_totalProtegees != _ancienTotal) {
      setState(() => _ancienTotal = _totalProtegees);
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A6B5C), Color(0xFF1A9F8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A6B5C).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.eco, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Espèces protégées observées',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Text(
                    // Nombre total (somme des nombreObserve pour espèces protégées)
                    '$_totalProtegees individus',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '${widget.observations.where((o) => o.especeProtegee).length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'espèces',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
