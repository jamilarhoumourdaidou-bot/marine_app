// lib/widgets/badge_protegee.dart

import 'package:flutter/material.dart';

/// Widget réutilisable : badge "Protégée" affiché sur les espèces protégées.
/// Stateless car il ne gère aucun état interne.
class BadgeProtegee extends StatelessWidget {
  final bool estProtegee;
  final bool grand; // taille optionnelle

  const BadgeProtegee({
    super.key,
    required this.estProtegee,
    this.grand = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!estProtegee) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: grand ? 12 : 8,
        vertical: grand ? 6 : 3,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFD32F2F),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield,
            color: Colors.white,
            size: grand ? 16 : 12,
          ),
          SizedBox(width: grand ? 6 : 4),
          Text(
            'Protégée',
            style: TextStyle(
              color: Colors.white,
              fontSize: grand ? 14 : 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
