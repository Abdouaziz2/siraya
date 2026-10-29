import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nioudem/core/theme/siraya_colors.dart';
import 'package:nioudem/core/theme/siraya_spacing.dart';
import 'package:nioudem/data/datasources/auth_remote_data_source.dart';
import 'package:nioudem/data/repositories/auth_repository_impl.dart';
import 'package:nioudem/domain/usecases/auth/send_otp_usecase.dart';
import 'package:nioudem/presentation/pages/auth/otp_page.dart';

/// Écran 5 · Téléphone (création / connexion) — Node Figma `32:10322`
///
/// Design Figma :
/// - Fond vert sombre (#003522)
/// - En-tête : "Bienvenue sur SIRAYA" (bold 25) + "Entrez votre numéro de téléphone..."
/// - Formulaire (#FCF9F4) avec coins arrondis supérieurs 28dp
/// - Champ Pays avec drapeau Sénégal (+221)
/// - Champ Numéro de téléphone (bold 20)
/// - Bouton "Recevoir le code" (#FF7900)
/// - Mentions légales en bas
class PhonePage extends StatefulWidget {
  const PhonePage({
    super.key,
    this.sendOtpUseCase,
  });

  final SendOtpUseCase? sendOtpUseCase;

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final TextEditingController _phoneController = TextEditingController(text: '77 123 45 67');
  bool _isLoading = false;
  late final SendOtpUseCase _sendOtpUseCase;

  @override
  void initState() {
    super.initState();
    _sendOtpUseCase = widget.sendOtpUseCase ??
        SendOtpUseCase(AuthRepositoryImpl(FirebaseAuthRemoteDataSourceImpl()));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final rawPhone = _phoneController.text.trim();
    final cleanPhone = rawPhone.replaceAll(RegExp(r'\s+'), '');

    if (cleanPhone.isEmpty || cleanPhone.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir un numéro de téléphone valide.'),
          backgroundColor: SirayaColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Format complet avec indicatif pays
    final fullNumber = cleanPhone.startsWith('+') ? cleanPhone : '+221$cleanPhone';

    try {
      await _sendOtpUseCase.call(
        phoneNumber: fullNumber,
        onCodeSent: (verificationId) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => OtpPage(
                phoneNumber: fullNumber,
                verificationId: verificationId,
              ),
            ),
          );
        },
        onError: (errorMessage) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: SirayaColors.error,
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: SirayaColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003522),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── En-tête (sur fond vert sombre #003522) ───────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SirayaSpacing.xl,
                SirayaSpacing.lg,
                SirayaSpacing.xl,
                SirayaSpacing.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenue sur SIRAYA',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: SirayaSpacing.xs),
                  Text(
                    'Entrez votre numéro de téléphone\npour commencer.',
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

            // ── Formulaire (Fond crème doux #FCF9F4) ─────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCF9F4),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SirayaSpacing.xl,
                    vertical: SirayaSpacing.xxl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Champ Pays
                      Text(
                        'Pays',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: SirayaSpacing.xs),
                      _buildCountryField(),

                      const SizedBox(height: SirayaSpacing.lg),

                      // 2. Champ Numéro de téléphone
                      Text(
                        'Numéro de téléphone',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: SirayaSpacing.xs),
                      _buildPhoneInputField(),

                      const SizedBox(height: SirayaSpacing.lg),

                      // 3. Information SMS
                      Center(
                        child: Text(
                          'Nous vous enverrons un code\nde vérification par SMS.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF4B5563),
                            height: 1.35,
                          ),
                        ),
                      ),

                      const SizedBox(height: SirayaSpacing.xxxl),

                      // 4. Bouton Recevoir le code (#FF7900)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7900),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _isLoading ? null : _onSubmit,
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
                                  'Recevoir le code',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.1,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: SirayaSpacing.lg),

                      // 5. Mentions légales
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'En continuant, vous acceptez nos',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF4B5563),
                              ),
                            ),
                            const SizedBox(height: 2),
                            InkWell(
                              onTap: () {
                                // Ouverture CGU / Confidentialité
                              },
                              child: Text(
                                'Conditions d’utilisation et Politique de confidentialité',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF141F1A),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
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

  // ── Widget Champ Pays (Sénégal +221 avec drapeau) ───────────────────
  Widget _buildCountryField() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: SirayaSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Drapeau Sénégal (Vert, Jaune + Étoile verte, Rouge)
          _buildSenegalFlag(),
          const SizedBox(width: SirayaSpacing.md),

          // Texte Pays + Indicatif
          Expanded(
            child: Text(
              'Sénégal (+221)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF141F1A),
              ),
            ),
          ),

          // Chevron déroulant
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF4B5563),
            size: 24,
          ),
        ],
      ),
    );
  }

  // ── Drapeau Sénégal vectoriel crisp ─────────────────────────────────
  Widget _buildSenegalFlag() {
    return Container(
      width: 28,
      height: 18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(child: Container(color: const Color(0xFF00853F))),
          Expanded(
            child: Container(
              color: const Color(0xFFFDEF42),
              child: const Center(
                child: Icon(
                  Icons.star,
                  size: 8,
                  color: Color(0xFF00853F),
                ),
              ),
            ),
          ),
          Expanded(child: Container(color: const Color(0xFFE31B23))),
        ],
      ),
    );
  }

  // ── Champ Numéro de Téléphone ───────────────────────────────────────
  Widget _buildPhoneInputField() {
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
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: const Color(0xFF141F1A),
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            hintText: '77 123 45 67',
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ),
      ),
    );
  }
}
