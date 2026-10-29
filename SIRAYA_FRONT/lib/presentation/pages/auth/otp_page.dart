import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nioudem/core/theme/siraya_colors.dart';
import 'package:nioudem/core/theme/siraya_spacing.dart';
import 'package:nioudem/data/datasources/auth_remote_data_source.dart';
import 'package:nioudem/data/repositories/auth_repository_impl.dart';
import 'package:nioudem/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:nioudem/presentation/pages/home/home_page.dart';

/// Écran 6 · Vérification OTP — Node Figma `32:10352`
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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _verifyOtpUseCase = widget.verifyOtpUseCase ??
        VerifyOtpUseCase(AuthRepositoryImpl(FirebaseAuthRemoteDataSourceImpl()));

    // Pré-remplir avec le code de test 123456 si numéro de test
    if (widget.verificationId.startsWith('test-verification-id')) {
      const testCode = '123456';
      for (int i = 0; i < testCode.length; i++) {
        _controllers[i].text = testCode[i];
      }
    }

    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        _timer?.cancel();
      }
    });
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
        // Redirection vers l'Accueil
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
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
            // ── En-tête ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SirayaSpacing.xl,
                SirayaSpacing.md,
                SirayaSpacing.xl,
                SirayaSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  const SizedBox(height: SirayaSpacing.xs),
                  Text(
                    'Vérifiez votre numéro',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: SirayaSpacing.xs),
                  Text(
                    'Nous avons envoyé un code au\n${widget.phoneNumber}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            // ── Formulaire OTP (#FCF9F4) ─────────────────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCF9F4),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: SirayaSpacing.xl,
                  vertical: SirayaSpacing.xxl,
                ),
                child: Column(
                  children: [
                    // Cases OTP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 44,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
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
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF141F1A),
                              ),
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                isDense: true,
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

                    // Expiration & Renvoi
                    Text(
                      _resendCountdown > 0
                          ? 'Disponible dans 00:${_resendCountdown.toString().padLeft(2, '0')}'
                          : 'Vous n\'avez pas reçu le code ?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    if (_resendCountdown == 0) ...[
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: () {
                          setState(() => _resendCountdown = 45);
                          _startCountdown();
                        },
                        child: Text(
                          'Renvoyer le code',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: SirayaColors.green,
                          ),
                        ),
                      ),
                    ],

                    const Spacer(),

                    // Bouton Vérifier (#FF7900)
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: SirayaSpacing.sm),

                    // Modifier le numéro
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Modifier le numéro',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4B5563),
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
