import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/wpgg_brand.dart';
import '../../features/ddragon/presentation/providers/ddragon_provider.dart';
import '../../features/riot/domain/entities/summoner_entity.dart';

/// Shared tag for profile avatar hero-style transitions.
const kWpggProfileAvatarHeroTag = 'wpgg_profile_avatar';

class WpggProfileAvatar extends StatelessWidget {
  const WpggProfileAvatar({
    super.key,
    required this.summoner,
    required this.ddragon,
    required this.size,
    this.heroTag = kWpggProfileAvatarHeroTag,
    this.enableHero = true,
  });

  final SummonerEntity summoner;
  final DDragonProvider? ddragon;
  final double size;
  final Object? heroTag;
  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    final avatar = _AvatarBody(
      summoner: summoner,
      ddragon: ddragon,
      size: size,
    );

    if (!enableHero || heroTag == null) {
      return avatar;
    }

    return Hero(
      tag: heroTag!,
      child: Material(
        color: Colors.transparent,
        child: avatar,
      ),
    );
  }
}

class _AvatarBody extends StatelessWidget {
  const _AvatarBody({
    required this.summoner,
    required this.ddragon,
    required this.size,
  });

  final SummonerEntity summoner;
  final DDragonProvider? ddragon;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (ddragon == null) {
      return SizedBox(
        width: size,
        height: size,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            color: WpggBrand.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person, color: WpggBrand.white),
        ),
      );
    }

    final dpr = MediaQuery.devicePixelRatioOf(context).clamp(1.0, 3.0);
    final cachePx = (size * dpr).round();

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: WpggBrand.primary,
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: ddragon!.profileIconUrl(summoner.profileIconId),
            width: size,
            height: size,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            memCacheWidth: cachePx,
            memCacheHeight: cachePx,
            errorWidget: (_, __, ___) => Icon(
              Icons.person,
              color: WpggBrand.white,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
