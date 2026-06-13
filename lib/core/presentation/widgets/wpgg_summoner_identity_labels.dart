import 'package:flutter/material.dart';

import '../../constants/app_fonts.dart';
import '../../constants/wpgg_brand.dart';
import '../../../features/riot/domain/entities/summoner_entity.dart';
import '../web/web_colors.dart';
import 'wpgg_server_tag.dart';

enum WpggSummonerIdentityLayout { vertical, horizontalBadges }

/// Summoner name, Riot ID tag (#tagLine), and platform server (region).
class WpggSummonerIdentityLabels extends StatelessWidget {
  const WpggSummonerIdentityLabels({
    super.key,
    required this.gameName,
    required this.tagLine,
    required this.region,
    this.useWebStyle = false,
    this.layout = WpggSummonerIdentityLayout.vertical,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.nameStyle,
    this.tagLineStyle,
    this.nameMaxLines = 1,
  });

  factory WpggSummonerIdentityLabels.fromSummoner(
    SummonerEntity summoner, {
    Key? key,
    bool useWebStyle = false,
    WpggSummonerIdentityLayout layout = WpggSummonerIdentityLayout.vertical,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    TextStyle? nameStyle,
    TextStyle? tagLineStyle,
    int nameMaxLines = 1,
  }) {
    return WpggSummonerIdentityLabels(
      key: key,
      gameName: summoner.gameName,
      tagLine: summoner.tagLine,
      region: summoner.region,
      useWebStyle: useWebStyle,
      layout: layout,
      crossAxisAlignment: crossAxisAlignment,
      nameStyle: nameStyle,
      tagLineStyle: tagLineStyle,
      nameMaxLines: nameMaxLines,
    );
  }

  final String gameName;
  final String tagLine;
  final String region;
  final bool useWebStyle;
  final WpggSummonerIdentityLayout layout;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle? nameStyle;
  final TextStyle? tagLineStyle;
  final int nameMaxLines;

  @override
  Widget build(BuildContext context) {
    if (layout == WpggSummonerIdentityLayout.horizontalBadges) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _WebBadge(text: gameName),
          if (tagLine.trim().isNotEmpty) ...[
            const SizedBox(width: 6),
            _WebBadge(text: '#${tagLine.trim()}'),
          ],
          if (region.trim().isNotEmpty) ...[
            const SizedBox(width: 6),
            WpggServerTag(region: region, useWebStyle: true),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          gameName,
          maxLines: nameMaxLines,
          overflow: TextOverflow.ellipsis,
          style: nameStyle ?? _defaultNameStyle(useWebStyle),
        ),
        if (tagLine.trim().isNotEmpty)
          Text(
            '#${tagLine.trim()}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tagLineStyle ?? _defaultTagLineStyle(useWebStyle),
          ),
        WpggServerTag(region: region, useWebStyle: useWebStyle),
      ],
    );
  }

  static TextStyle _defaultNameStyle(bool useWebStyle) {
    if (useWebStyle) {
      return const TextStyle(
        fontFamily: AppFonts.lexendDeca,
        color: WebColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      );
    }
    return const TextStyle(
      fontFamily: AppFonts.lexendDeca,
      color: WpggBrand.white,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle _defaultTagLineStyle(bool useWebStyle) {
    if (useWebStyle) {
      return const TextStyle(
        fontFamily: AppFonts.lexendDeca,
        color: WebColors.textMuted,
        fontSize: 11,
      );
    }
    return const TextStyle(
      fontFamily: AppFonts.lexendDeca,
      color: WpggBrand.textMuted,
      fontSize: 12,
    );
  }
}

class _WebBadge extends StatelessWidget {
  const _WebBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: WebColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: WebColors.border),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: WebColors.textSecondary,
          fontSize: 12,
        ),
      ),
    );
  }
}
