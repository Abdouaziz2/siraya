import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';

class SirayaLogo extends StatelessWidget {
  const SirayaLogo({super.key, required this.size, this.dark = false});

  final double size;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final color = dark ? SirayaColors.green : Colors.white;
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/siraya_logo_transparent.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/siraya_logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.2), width: 1.4),
                ),
                child: Center(
                  child: Text(
                    'S',
                    style: TextStyle(
                      color: color,
                      fontSize: size * 0.62,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
