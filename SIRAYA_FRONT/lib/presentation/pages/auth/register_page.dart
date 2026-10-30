import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nioudem/core/constants/siraya_countries.dart';
import 'package:nioudem/core/theme/siraya_spacing.dart';
import 'package:nioudem/domain/entities/country_entity.dart';
import 'package:nioudem/presentation/pages/home/home_page.dart';
import 'package:nioudem/presentation/widgets/country_picker_bottom_sheet.dart';

/// Écran 8 · Nouveau compte (créer le profil) — Node Figma `32:10400`
///
/// Design Figma :
/// - Fond vert sombre (#003522)
/// - En-tête : "Complétez votre profil" + "Quelques informations pour finaliser..."
/// - Formulaire (#FCF9F4) avec :
///   - Prénom (placeholder: "Baye")
///   - Nom (placeholder: "Seck")
///   - Email (optionnel) (placeholder: "baye@email.com")
///   - Pays de résidence (Drapeau + Sénégal + chevron)
/// - Bouton "Créer mon compte" (#FF7900)
/// - Lien "Retour"
class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    this.phone,
  });

  final String? phone;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstNameController = TextEditingController(text: 'Baye');
  final TextEditingController _lastNameController = TextEditingController(text: 'Seck');
  final TextEditingController _emailController = TextEditingController(text: 'baye@email.com');
  CountryEntity _selectedCountry = SirayaCountries.senegal;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _openCountryPicker() async {
    final picked = await CountryPickerBottomSheet.show(
      context,
      currentCountry: _selectedCountry,
    );

    if (picked != null && picked != _selectedCountry) {
      setState(() => _selectedCountry = picked);
    }
  }

  void _onCreateAccount() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez renseigner votre prénom et votre nom.'),
          backgroundColor: Color(0xFFB91C1C),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulation de création et redirection vers l'accueil
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003522),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── En-tête (#003522) ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SirayaSpacing.xl,
                SirayaSpacing.lg,
                SirayaSpacing.xl,
                SirayaSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complétez votre profil',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: SirayaSpacing.xs),
                  Text(
                    'Quelques informations pour\nfinaliser la création de votre compte.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            // ── Formulaire (#FCF9F4) ─────────────────────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCF9F4),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SirayaSpacing.xl,
                    vertical: SirayaSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Champ Prénom
                      _buildFieldLabel('Prénom'),
                      const SizedBox(height: SirayaSpacing.xs),
                      _buildTextInputField(
                        controller: _firstNameController,
                        hint: 'Baye',
                      ),

                      const SizedBox(height: SirayaSpacing.md),

                      // 2. Champ Nom
                      _buildFieldLabel('Nom'),
                      const SizedBox(height: SirayaSpacing.xs),
                      _buildTextInputField(
                        controller: _lastNameController,
                        hint: 'Seck',
                      ),

                      const SizedBox(height: SirayaSpacing.md),

                      // 3. Champ Email (optionnel)
                      _buildFieldLabel('Email (optionnel)'),
                      const SizedBox(height: SirayaSpacing.xs),
                      _buildTextInputField(
                        controller: _emailController,
                        hint: 'baye@email.com',
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: SirayaSpacing.md),

                      // 4. Champ Pays de résidence
                      _buildFieldLabel('Pays de résidence'),
                      const SizedBox(height: SirayaSpacing.xs),
                      _buildCountrySelectorField(),

                      const SizedBox(height: SirayaSpacing.xxl),

                      // 5. Bouton Créer mon compte (#FF7900)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7900),
                            foregroundColor: const Color(0xFF003522),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _isLoading ? null : _onCreateAccount,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Créer mon compte',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: SirayaSpacing.md),

                      // 6. Lien Retour
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Retour',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF003C28),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF222923),
      ),
    );
  }

  Widget _buildTextInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: SirayaSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF222923),
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF9CA3AF),
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildCountrySelectorField() {
    return InkWell(
      onTap: _openCountryPicker,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: SirayaSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            // Drapeau
            Text(
              _selectedCountry.flagEmoji,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(width: SirayaSpacing.md),

            // Nom du pays
            Expanded(
              child: Text(
                _selectedCountry.name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF222923),
                ),
              ),
            ),

            // Chevron
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF4B5563),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
