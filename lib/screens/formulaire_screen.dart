// lib/screens/formulaire_screen.dart
// Écran 3 : Formulaire de création avec validation

import 'package:flutter/material.dart';
import '../models/observation.dart';

class FormulaireScreen extends StatefulWidget {
  final Function(Observation) onAjouter;

  const FormulaireScreen({super.key, required this.onAjouter});

  @override
  State<FormulaireScreen> createState() => _FormulaireScreenState();
}

class _FormulaireScreenState extends State<FormulaireScreen> {
  // Clé pour valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs des champs texte
  final _especeCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();

  // État du formulaire
  String _zoneSelectionnee = 'Joal-Fadiouth';
  DateTime _dateSelectionnee = DateTime.now();
  bool _estProtegee = false;
  bool _enChargement = false;

  // Zones réelles du Sénégal
  final List<String> _zones = [
    'Joal-Fadiouth',
    'Bamboung',
    'Abéné',
    'Saint-Louis',
    'Kayar',
    'Pointe de Sarène',
  ];

  @override
  void dispose() {
    _especeCtrl.dispose();
    _nombreCtrl.dispose();
    super.dispose();
  }

  // Ouvre le sélecteur de date
  Future<void> _choisirDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateSelectionnee,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0A6B5C),
          ),
        ),
        child: child!,
      ),
    );
    if (date != null) {
      // setState met à jour _dateSelectionnee → rebuild du widget date
      setState(() => _dateSelectionnee = date);
    }
  }

  // Soumettre le formulaire avec validation
  Future<void> _soumettre() async {
    // Validation de tous les champs
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enChargement = true);

    // Création de l'objet Observation
    final nouvelleObs = Observation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      espece: _especeCtrl.text.trim(),
      zone: _zoneSelectionnee,
      nombreObserve: int.parse(_nombreCtrl.text.trim()),
      date: _dateSelectionnee,
      especeProtegee: _estProtegee,
    );

    // Appel du callback pour ajouter à la liste principale
    widget.onAjouter(nouvelleObs);

    setState(() => _enChargement = false);

    // Retour à la liste avec confirmation
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Observation de "${nouvelleObs.espece}" ajoutée !'),
          backgroundColor: const Color(0xFF0A6B5C),
        ),
      );
      Navigator.pop(context);
    }
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
        title: const Text('Nouvelle observation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre du formulaire
              const Text(
                'Enregistrer une observation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A6B5C),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tous les champs sont obligatoires.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Champ : Espèce
              _LabelChamp(label: 'Espèce observée'),
              TextFormField(
                controller: _especeCtrl,
                decoration: _decoration('Ex : Tortue verte, Dauphin...'),
                // Validation : champ non vide
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Veuillez saisir le nom de l\'espèce';
                  }
                  if (val.trim().length < 2) {
                    return 'Le nom doit contenir au moins 2 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ : Zone (menu déroulant)
              _LabelChamp(label: 'Zone marine'),
              DropdownButtonFormField<String>(
                value: _zoneSelectionnee,
                decoration: _decoration('Sélectionner une zone'),
                items: _zones
                    .map((z) => DropdownMenuItem(value: z, child: Text(z)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _zoneSelectionnee = val);
                },
              ),
              const SizedBox(height: 16),

              // Champ : Nombre observé
              _LabelChamp(label: 'Nombre d\'individus observés'),
              TextFormField(
                controller: _nombreCtrl,
                keyboardType: TextInputType.number,
                decoration: _decoration('Ex : 5'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Veuillez saisir un nombre';
                  }
                  final n = int.tryParse(val.trim());
                  if (n == null || n <= 0) {
                    return 'Le nombre doit être un entier positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ : Date
              _LabelChamp(label: 'Date d\'observation'),
              InkWell(
                onTap: _choisirDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Color(0xFF0A6B5C)),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(_dateSelectionnee),
                        style: const TextStyle(fontSize: 15),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Champ : Espèce protégée (switch)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield, color: Color(0xFFD32F2F)),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Espèce protégée',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                    // setState appelé sur le Switch → rebuild du badge
                    Switch(
                      value: _estProtegee,
                      onChanged: (val) => setState(() => _estProtegee = val),
                      activeColor: const Color(0xFFD32F2F),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Bouton soumettre
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A6B5C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _enChargement ? null : _soumettre,
                  child: _enChargement
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Enregistrer l\'observation',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: 12),

              // Bouton annuler
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0A6B5C)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Annuler',
                    style: TextStyle(color: Color(0xFF0A6B5C), fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Décoration commune pour les champs de texte
  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color(0xFF0A6B5C), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}

// Widget label réutilisable
class _LabelChamp extends StatelessWidget {
  final String label;
  const _LabelChamp({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xFF333333),
        ),
      ),
    );
  }
}
