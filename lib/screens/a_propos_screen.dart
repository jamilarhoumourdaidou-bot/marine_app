// lib/screens/a_propos_screen.dart
// Écran "À propos" obligatoire selon le cahier des charges

import 'package:flutter/material.dart';

class AProposScreen extends StatelessWidget {
  const AProposScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F6),
      appBar: AppBar(title: const Text('À propos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo / illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A6B5C), Color(0xFF1A9F8A)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.water, color: Colors.white, size: 64),
            ),
            const SizedBox(height: 20),

            const Text(
              'Aires Marines Protégées',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A6B5C),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'ODD 14 — Vie aquatique',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),

            const SizedBox(height: 32),

            _InfoCard(
              icone: Icons.person,
              titre: 'Développeuse',
              contenu: 'Jamila Rhoumour\nDAR26 — ESMT Dakar',
            ),
            _InfoCard(
              icone: Icons.source,
              titre: 'Source des données',
              contenu:
                  'Données collectées sur le terrain dans les aires marines '
                  'protégées du Sénégal :\n• Joal-Fadiouth\n• Bamboung\n• Kayar',
            ),
            _InfoCard(
              icone: Icons.calendar_today,
              titre: 'Date de collecte',
              contenu: 'Mars — Juin 2024',
            ),
            _InfoCard(
              icone: Icons.info_outline,
              titre: 'Objectif',
              contenu:
                  'Cette application permet aux agents de terrain de recenser '
                  'les espèces observées dans les aires marines protégées du Sénégal '
                  'et d\'identifier les espèces protégées pour leur suivi.',
            ),

            const SizedBox(height: 16),
            const Text(
              'Module Développement Multiplateforme\nESMT — Projet Flutter DAR26',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icone;
  final String titre;
  final String contenu;

  const _InfoCard({
    required this.icone,
    required this.titre,
    required this.contenu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0A6B5C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icone, color: const Color(0xFF0A6B5C), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF0A6B5C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contenu,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
