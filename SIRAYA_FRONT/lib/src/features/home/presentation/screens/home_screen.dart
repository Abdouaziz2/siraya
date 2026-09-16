import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';
import 'package:nioudem/src/features/auth/models/auth_session.dart';
import 'package:nioudem/src/features/auth/presentation/screens/auth_choice_screen.dart';
import 'package:nioudem/src/shared/widgets/siraya_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.session});

  final AuthSession session;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.sizeOf(context).width < 380 ? 16.0 : 18.0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _HomeHeader(session: session),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(horizontalPadding),
                children: [
                  _UserSummaryCard(session: session),
                  const SizedBox(height: 16),
                  const _EmptySection(
                    icon: Icons.confirmation_number_outlined,
                    title: 'Aucune réservation',
                    message: 'Vos réservations apparaîtront ici après votre premier achat.',
                  ),
                  const SizedBox(height: 12),
                  const _EmptySection(
                    icon: Icons.route_outlined,
                    title: 'Recherche de trajets',
                    message: 'Les trajets seront affichés dès que le module de recherche sera connecté.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.session});

  final AuthSession session;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: const BoxDecoration(
        color: SirayaColors.green,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
      ),
      child: Row(
        children: [
          const SirayaLogo(size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour, ${session.user.displayName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  session.user.phoneNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            color: Colors.white,
            tooltip: 'Déconnexion',
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(builder: (_) => const AuthChoiceScreen()),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}

class _UserSummaryCard extends StatelessWidget {
  const _UserSummaryCard({required this.session});

  final AuthSession session;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Compte',
            style: TextStyle(
              color: SirayaColors.darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          _InfoRow(label: 'Prénom', value: _valueOrEmpty(session.user.firstName)),
          const SizedBox(height: 10),
          _InfoRow(label: 'Nom', value: _valueOrEmpty(session.user.lastName)),
          const SizedBox(height: 10),
          _InfoRow(label: 'Téléphone', value: session.user.phoneNumber),
          const SizedBox(height: 10),
          _InfoRow(
            label: 'Téléphone vérifié',
            value: session.user.phoneVerified ? 'Oui' : 'Non',
          ),
          const SizedBox(height: 10),
          _InfoRow(
            label: 'Profil',
            value: session.profileComplete ? 'Complet' : 'À compléter',
          ),
        ],
      ),
    );
  }

  static String _valueOrEmpty(String? value) {
    if (value == null || value.trim().isEmpty) return 'Non renseigné';
    return value.trim();
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 118,
          child: Text(
            label,
            style: const TextStyle(color: SirayaColors.muted, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: SirayaColors.darkGreen,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: SirayaColors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: SirayaColors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: SirayaColors.darkGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: SirayaColors.muted,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
