import 'package:flutter/material.dart';
import 'package:nioudem/src/core/network/api_exception.dart';
import 'package:nioudem/src/features/auth/data/auth_api.dart';
import 'package:nioudem/src/features/home/presentation/screens/home_screen.dart';
import 'package:nioudem/src/shared/validators/input_validators.dart';
import 'package:nioudem/src/shared/widgets/siraya_auth_scaffold.dart';
import 'package:nioudem/src/shared/widgets/siraya_buttons.dart';
import 'package:nioudem/src/shared/widgets/siraya_text_field.dart';

class LoginPinScreen extends StatefulWidget {
  const LoginPinScreen({super.key});

  @override
  State<LoginPinScreen> createState() => _LoginPinScreenState();
}

class _LoginPinScreenState extends State<LoginPinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _api = AuthApi();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final session = await _api.loginWithPin(
        phoneNumber: _phoneController.text.trim(),
        pin: _pinController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => HomeScreen(session: session)),
        (_) => false,
      );
    } on ApiException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Impossible de contacter le serveur');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SirayaAuthScaffold(
      title: 'Connexion',
      subtitle: 'Entrez votre numéro et votre PIN personnel.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SirayaTextField(
              controller: _phoneController,
              label: 'Numéro de téléphone',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: InputValidators.phone,
            ),
            const SizedBox(height: 12),
            SirayaTextField(
              controller: _pinController,
              label: 'Code PIN',
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              validator: InputValidators.pin,
            ),
            const SizedBox(height: 18),
            SirayaPrimaryButton(
              label: 'Se connecter',
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
