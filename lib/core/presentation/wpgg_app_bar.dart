import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_fonts.dart';
import '../constants/wpgg_brand.dart';
import '../l10n/l10n_extension.dart';
import '../../features/ddragon/presentation/providers/ddragon_provider.dart';
import '../../features/riot/domain/entities/summoner_entity.dart';

class WpggAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WpggAppBar({
    super.key,
    this.title,
    this.showBack = false,
    this.summoner,
    this.ddragon,
  });

  final String? title;
  final bool showBack;
  final SummonerEntity? summoner;
  final DDragonProvider? ddragon;

  static const _profileIconSize = 40.0;
  static const _homeTextStyle = TextStyle(
    fontFamily: AppFonts.lexendDeca,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.2,
  );

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: title != null,
      leading: showBack
          ? IconButton(
              padding: const EdgeInsets.all(12),
              icon: Image.asset(
                'assets/icons/arrow_left.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : title == null && summoner != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Center(
                    child: _ProfileIcon(
                      summoner: summoner!,
                      ddragon: ddragon,
                    ),
                  ),
                )
              : null,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: WpggBrand.white,
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            )
          : summoner != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.hello,
                      style: _homeTextStyle.copyWith(
                        color: WpggBrand.textMuted,
                      ),
                    ),
                    Text(
                      summoner!.gameName,
                      style: _homeTextStyle.copyWith(
                        color: WpggBrand.white,
                      ),
                    ),
                  ],
                )
              : null,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: WpggBrand.white),
              onPressed: () {},
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: WpggBrand.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon({
    required this.summoner,
    required this.ddragon,
  });

  final SummonerEntity summoner;
  final DDragonProvider? ddragon;

  @override
  Widget build(BuildContext context) {
    if (ddragon == null) {
      return const SizedBox(
        width: WpggAppBar._profileIconSize,
        height: WpggAppBar._profileIconSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: WpggBrand.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person, color: WpggBrand.white, size: 24),
        ),
      );
    }

    return SizedBox(
      width: WpggAppBar._profileIconSize,
      height: WpggAppBar._profileIconSize,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: WpggBrand.primary,
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: ddragon!.profileIconUrl(summoner.profileIconId),
            width: WpggAppBar._profileIconSize,
            height: WpggAppBar._profileIconSize,
            fit: BoxFit.contain,
            errorWidget: (_, __, ___) => const Icon(
              Icons.person,
              color: WpggBrand.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
