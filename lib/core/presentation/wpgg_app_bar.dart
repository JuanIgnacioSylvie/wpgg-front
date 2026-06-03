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
              icon: const Icon(Icons.arrow_back_ios_new, color: WpggBrand.white),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : summoner != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: CircleAvatar(
                    backgroundColor: WpggBrand.primary,
                    backgroundImage: ddragon != null
                        ? CachedNetworkImageProvider(
                            ddragon!.profileIconUrl(summoner!.profileIconId),
                          )
                        : null,
                    child: ddragon == null
                        ? const Icon(Icons.person, color: WpggBrand.white)
                        : null,
                  ),
                )
              : null,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                color: WpggBrand.white,
                fontWeight: FontWeight.w700,
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
                      style: const TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        color: WpggBrand.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      summoner!.gameName,
                      style: const TextStyle(
                        color: WpggBrand.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
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
