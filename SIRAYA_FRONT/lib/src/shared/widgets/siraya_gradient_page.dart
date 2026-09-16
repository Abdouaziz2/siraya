import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';

class SirayaGradientPage extends StatelessWidget {
  const SirayaGradientPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [SirayaColors.darkGreen, SirayaColors.green],
          ),
        ),
        child: child,
      ),
    );
  }
}
