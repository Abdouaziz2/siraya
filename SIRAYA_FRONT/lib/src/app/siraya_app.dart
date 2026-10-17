import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';
import 'package:nioudem/src/core/theme/siraya_theme.dart';
import 'package:nioudem/src/shared/widgets/siraya_logo.dart';

class SirayaApp extends StatelessWidget {
  const SirayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIRAYA',
      debugShowCheckedModeBanner: false,
      theme: SirayaTheme.light(),
      home: const Scaffold(
        backgroundColor: SirayaColors.background,
        body: Center(
          child: SirayaLogo(size: 40),
        ),
      ),
    );
  }
}
