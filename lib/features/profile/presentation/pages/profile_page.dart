import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/locale/locale_provider.dart';
import '../../../../core/presentation/wpgg_gradient_scaffold.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeProvider = context.watch<LocaleProvider>();

    return WpggGradientScaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
        children: [
          Text(
            l10n.profile,
            style: const TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: WpggBrand.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          _LanguageCard(localeProvider: localeProvider),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () {
              context.read<AuthBloc>().add(const LogoutRequested());
              context.go('/login');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: WpggBrand.white,
              side: const BorderSide(color: WpggBrand.white),
            ),
            child: Text(l10n.logOut),
          ),
        ],
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({required this.localeProvider});

  final LocaleProvider localeProvider;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEnglish = localeProvider.locale.languageCode == 'en';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WpggBrand.cardSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.language,
            style: const TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: false,
                label: Text(l10n.languageSpanish),
              ),
              ButtonSegment(
                value: true,
                label: Text(l10n.languageEnglish),
              ),
            ],
            selected: {isEnglish},
            onSelectionChanged: (selected) {
              final english = selected.first;
              if (english) {
                localeProvider.setEnglish();
              } else {
                localeProvider.setSpanish();
              }
            },
          ),
        ],
      ),
    );
  }
}
