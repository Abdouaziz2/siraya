import 'package:flutter/material.dart';
import 'package:nioudem/src/core/network/api_exception.dart';
import 'package:nioudem/src/features/auth/data/auth_api.dart';
import 'package:nioudem/src/features/home/presentation/screens/home_screen.dart';
import 'package:nioudem/src/shared/validators/input_validators.dart';
import 'package:nioudem/src/shared/widgets/siraya_auth_scaffold.dart';
import 'package:nioudem/src/shared/widgets/siraya_buttons.dart';
import 'package:nioudem/src/shared/widgets/siraya_text_field.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _api = AuthApi();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  final _pinConfirmationController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    _pinConfirmationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final session = await _api.createPin(
        firstName: _emptyToNull(_firstNameController.text),
        lastName: _emptyToNull(_lastNameController.text),
        phoneNumber: _phoneController.text.trim(),
        pin: _pinController.text,
        pinConfirmation: _pinConfirmationController.text,
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

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SirayaAuthScaffold(
      title: 'Créez votre compte',
      subtitle: 'Renseignez votre numéro et choisissez un PIN à 4 chiffres.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SirayaTextField(
              controller: _firstNameController,
              label: 'Prénom',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            SirayaTextField(
              controller: _lastNameController,
              label: 'Nom',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
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
              textInputAction: TextInputAction.next,
              validator: InputValidators.pin,
            ),
            const SizedBox(height: 12),
            SirayaTextField(
              controller: _pinConfirmationController,
              label: 'Confirmer le PIN',
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              validator: (value) {
                final pinError = InputValidators.pin(value);
                if (pinError != null) return pinError;
                if (value != _pinController.text) return 'Les PIN ne correspondent pas';
                return null;
              },
            ),
            const SizedBox(height: 18),
            SirayaPrimaryButton(
              label: 'Créer mon compte',
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
