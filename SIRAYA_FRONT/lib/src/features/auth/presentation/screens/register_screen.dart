import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';
import 'package:nioudem/src/core/theme/siraya_spacing.dart';

/// Écran d'inscription — placeholder.
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SirayaColors.background,
      appBar: AppBar(
        title: const Text('Inscription'),
        backgroundColor: SirayaColors.green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(SirayaSpacing.xl),
          child: Text(
            'Formulaire inscription\n(À implémenter)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: SirayaColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

