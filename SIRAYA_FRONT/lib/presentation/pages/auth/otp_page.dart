import 'package:flutter/material.dart';
import 'package:nioudem/core/theme/siraya_colors.dart';
import 'package:nioudem/core/theme/siraya_spacing.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SirayaColors.background,
      appBar: AppBar(
        title: const Text('Code OTP'),
        backgroundColor: SirayaColors.green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(SirayaSpacing.xl),
          child: Text(
            'Vérification OTP\n(À implémenter)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: SirayaColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
