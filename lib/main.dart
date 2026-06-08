// lib/main.dart

import 'package:flutter/material.dart';
import 'models/observation.dart';
import 'screens/liste_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/formulaire_screen.dart';
import 'screens/a_propos_screen.dart';

void main() {
  runApp(const MarineApp());
}

class MarineApp extends StatefulWidget {
  const MarineApp({super.key});

  @override
  State<MarineApp> createState() => _MarineAppState();
}

class _MarineAppState extends State<MarineApp> {
  // Liste centrale des observations (état global passé entre écrans)
  final List<Observation> _observations = [
    Observation(
      id: '1',
      espece: 'Tortue verte',
      zone: 'Joal-Fadiouth',
      nombreObserve: 3,
      date: DateTime(2024, 3, 10),
      especeProtegee: true,
    ),
    Observation(
      id: '2',
      espece: 'Dauphin commun',
      zone: 'Bamboung',
      nombreObserve: 7,
      date: DateTime(2024, 4, 2),
      especeProtegee: true,
    ),
    Observation(
      id: '3',
      espece: 'Mérou brun',
      zone: 'Joal-Fadiouth',
      nombreObserve: 12,
      date: DateTime(2024, 4, 15),
      especeProtegee: false,
    ),
    Observation(
      id: '4',
      espece: 'Raie pastenague',
      zone: 'Bamboung',
      nombreObserve: 2,
      date: DateTime(2024, 5, 1),
      especeProtegee: true,
    ),
    Observation(
      id: '5',
      espece: 'Barracuda',
      zone: 'Joal-Fadiouth',
      nombreObserve: 9,
      date: DateTime(2024, 5, 20),
      especeProtegee: false,
    ),
  ];

  void _ajouterObservation(Observation obs) {
    setState(() {
      _observations.add(obs);
    });
  }

  void _supprimerObservation(String id) {
    setState(() {
      _observations.removeWhere((o) => o.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aires Marines Protégées',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A6B5C), // Vert océan profond
          primary: const Color(0xFF0A6B5C),
          secondary: const Color(0xFF1A9F8A),
          background: const Color(0xFFF0F7F6),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A6B5C),
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        useMaterial3: true,
        fontFamily: 'Georgia',
      ),
      // Navigation par routes nommées
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => ListeScreen(
                observations: _observations,
                onSupprimer: _supprimerObservation,
              ),
            );
          case '/detail':
            final obs = settings.arguments as Observation;
            return MaterialPageRoute(
              builder: (_) => DetailScreen(
                observation: obs,
                onSupprimer: _supprimerObservation,
              ),
            );
          case '/formulaire':
            return MaterialPageRoute(
              builder: (_) => FormulaireScreen(
                onAjouter: _ajouterObservation,
              ),
            );
          case '/apropos':
            return MaterialPageRoute(
              builder: (_) => const AProposScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => ListeScreen(
                observations: _observations,
                onSupprimer: _supprimerObservation,
              ),
            );
        }
      },
    );
  }
}
