import 'package:flutter/material.dart';
import 'package:nioudem/core/theme/siraya_colors.dart';
import 'package:nioudem/core/theme/siraya_spacing.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SirayaColors.background,
      appBar: AppBar(
        title: const Text('SIRAYA'),
        backgroundColor: SirayaColors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(SirayaSpacing.xl),
          child: Text(
            'Accueil\n(À implémenter)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: SirayaColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
