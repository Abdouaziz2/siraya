import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nioudem/core/theme/siraya_colors.dart';
import 'package:nioudem/core/theme/siraya_spacing.dart';
import 'package:nioudem/data/datasources/auth_remote_data_source.dart';
import 'package:nioudem/data/repositories/auth_repository_impl.dart';
import 'package:nioudem/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:nioudem/presentation/pages/auth/register_page.dart';

/// Écran 6 · Vérification OTP — Node Figma `32:10352`
///
/// Design Figma :
/// - Fond vert sombre (#003522)
/// - Conteneur blanc/crème (#FCF9F4) avec coins arrondis 30dp
/// - Titre "Vérifiez votre numéro" (#003C28, bold 26)
/// - "Nous avons envoyé un code à" + Numéro en gras (#222923)
/// - 6 cases OTP (Radius 8, bold 28)
/// - "Code expire dans 01:45" (#A94700)
/// - "Disponible dans 00:45" / "Renvoyer le code"
/// - Bouton "Vérifier" (#FF7900)
/// - Lien "Modifier le numéro" (#003C28)
class OtpPage extends StatefulWidget {
  const OtpPage({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    this.verifyOtpUseCase,
  });

  final String phoneNumber;
  final String verificationId;
  final VerifyOtpUseCase? verifyOtpUseCase;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  late final VerifyOtpUseCase _verifyOtpUseCase;

  int _resendCountdown = 45;
  int _expireCountdown = 105; // 01:45
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _verifyOtpUseCase = widget.verifyOtpUseCase ??
        VerifyOtpUseCase(AuthRepositoryImpl(FirebaseAuthRemoteDataSourceImpl()));

    // Pré-remplissage du code de test 123456 pour fluidifier les tests
    if (widget.verificationId.startsWith('test-verification-id')) {
      const testCode = '123456';
      for (int i = 0; i < testCode.length; i++) {
        _controllers[i].text = testCode[i];
      }
    }

    _startTimers();
  }

  void _startTimers() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_resendCountdown > 0) _resendCountdown--;
        if (_expireCountdown > 0) _expireCountdown--;
      });
    });
  }

  String _formatTimer(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _onVerify() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir le code reçu par SMS.'),
          backgroundColor: SirayaColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _verifyOtpUseCase.call(
        verificationId: widget.verificationId,
        smsCode: code,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (user != null) {
        // Redirection vers l'Écran 8 (Compléter le profil) ou Accueil
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => RegisterPage(phone: widget.phoneNumber),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Code incorrect ou expiré.'),
            backgroundColor: SirayaColors.error,
          ),
        );
      }
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
            // Barre supérieure (Bouton retour)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SirayaSpacing.lg,
                vertical: SirayaSpacing.xs,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Conteneur principal (#FCF9F4)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCF9F4),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: SirayaSpacing.xl,
                  vertical: SirayaSpacing.xl,
                ),
                child: Column(
                  children: [
                    // Titre & Instructions
                    Text(
                      'Vérifiez votre numéro',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF003C28),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: SirayaSpacing.sm),
                    Text(
                      'Nous avons envoyé un code à',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF222923),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.phoneNumber,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF222923),
                      ),
                    ),

                    const SizedBox(height: SirayaSpacing.xxl),

                    // 6 Cases OTP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 46,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFD1D5DB),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF222923),
                              ),
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (val) {
                                if (val.isNotEmpty && index < 5) {
                                  _focusNodes[index + 1].requestFocus();
                                } else if (val.isEmpty && index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }
                              },
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: SirayaSpacing.lg),

                    // Expiration du code (#A94700)
                    Text(
                      'Code expire dans ${_formatTimer(_expireCountdown)}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFA94700),
                      ),
                    ),

                    const SizedBox(height: SirayaSpacing.xs),

                    // Renvoi du code
                    if (_resendCountdown > 0)
                      Text(
                        'Disponible dans ${_formatTimer(_resendCountdown)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF4B5563),
                        ),
                      )
                    else
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _resendCountdown = 45;
                            _expireCountdown = 105;
                          });
                        },
                        child: Text(
                          'Renvoyer le code',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF003C28),
                          ),
                        ),
                      ),

                    const Spacer(),

                    // Bouton Vérifier (#FF7900)
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
                        onPressed: _isLoading ? null : _onVerify,
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
                                'Vérifier',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: SirayaSpacing.sm),

                    // Lien Modifier le numéro
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Modifier le numéro',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF003C28),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
