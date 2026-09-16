import 'package:flutter/material.dart';
import 'package:nioudem/src/features/auth/presentation/screens/create_pin_screen.dart';
import 'package:nioudem/src/features/auth/presentation/screens/login_pin_screen.dart';
import 'package:nioudem/src/shared/widgets/siraya_auth_scaffold.dart';
import 'package:nioudem/src/shared/widgets/siraya_buttons.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SirayaAuthScaffold(
      title: 'Bienvenue sur SIRAYA',
      subtitle: 'Connectez-vous avec votre numéro et votre code PIN.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 18),
          SirayaPrimaryButton(
            label: 'Créer mon compte',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const CreatePinScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          SirayaSecondaryButton(
            label: 'J’ai déjà un compte',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const LoginPinScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
