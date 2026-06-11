import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../domain/legal_section.dart';

class LegalDocumentBody extends StatelessWidget {
  const LegalDocumentBody({
    super.key,
    required this.subtitle,
    required this.lastUpdated,
    required this.sections,
    this.useWebStyle = false,
    this.scrollable = true,
    this.bottomPadding = 32,
  });

  final String subtitle;
  final String lastUpdated;
  final List<LegalSection> sections;
  final bool useWebStyle;
  final bool scrollable;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final mutedColor = useWebStyle
        ? WebColors.textSecondary
        : WpggBrand.cardTextDark.withValues(alpha: 0.7);
    final titleColor =
        useWebStyle ? WebColors.textPrimary : WpggBrand.cardTextDark;
    final bodyColor = useWebStyle
        ? WebColors.textSecondary
        : WpggBrand.cardTextDark.withValues(alpha: 0.85);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: useWebStyle ? WebColors.accent : WpggBrand.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          lastUpdated,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 12,
            color: mutedColor,
          ),
        ),
        const SizedBox(height: 20),
        ...sections.map(
          (section) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _SectionBlock(
              section: section,
              titleColor: titleColor,
              bodyColor: bodyColor,
              useWebStyle: useWebStyle,
            ),
          ),
        ),
        SizedBox(height: bottomPadding),
      ],
    );

    if (!scrollable) return content;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: content,
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.section,
    required this.titleColor,
    required this.bodyColor,
    required this.useWebStyle,
  });

  final LegalSection section;
  final Color titleColor;
  final Color bodyColor;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final paragraphStyle = TextStyle(
      fontFamily: AppFonts.lexendDeca,
      fontSize: 14,
      height: 1.55,
      color: bodyColor,
    );
    final bulletStyle = TextStyle(
      fontFamily: AppFonts.lexendDeca,
      fontSize: 14,
      height: 1.5,
      color: bodyColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: titleColor,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 8),
        ...section.paragraphs.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(p, style: paragraphStyle),
          ),
        ),
        if (section.bullets.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: section.bullets.map((bullet) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 7, right: 10),
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: useWebStyle
                                ? WebColors.accent
                                : WpggBrand.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Expanded(child: Text(bullet, style: bulletStyle)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
