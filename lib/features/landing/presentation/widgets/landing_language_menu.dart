import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/locale/locale_provider.dart';
import '../../../../core/presentation/web/web_colors.dart';

class LandingLanguageMenu extends StatelessWidget {
  const LandingLanguageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final l10n = context.l10n;
    final current = localeProvider.languageCode.toUpperCase();

    return PopupMenuButton<String>(
      tooltip: l10n.language,
      offset: const Offset(0, 40),
      color: WebColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: WebColors.border),
      ),
      onSelected: (code) => localeProvider.setLocale(Locale(code)),
      itemBuilder: (menuContext) => [
        for (final code in LocaleProvider.supportedLanguageCodes)
          PopupMenuItem<String>(
            value: code,
            child: Row(
              children: [
                SizedBox(
                  width: 22,
                  child: localeProvider.languageCode == code
                      ? const Icon(
                          Icons.check,
                          size: 18,
                          color: WebColors.accent,
                        )
                      : null,
                ),
                Text(
                  menuContext.languageLabelForCode(code),
                  style: const TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    fontSize: 14,
                    color: WebColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.language,
              size: 18,
              color: WebColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              current,
              style: const TextStyle(
                fontFamily: AppFonts.lexendDeca,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: WebColors.textSecondary,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: WebColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
