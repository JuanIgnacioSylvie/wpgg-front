import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_skeleton.dart';
import '../../domain/entities/mission_card_entity.dart';
import '../bloc/missions_bloc.dart';
import '../utils/pick_mission_utils.dart';
import 'mission_spend_dialog.dart';
import 'pick_offers_header.dart';
import 'web_filter_chips.dart';
import 'web_mission_pick_card.dart';

Future<void> showPickMissionsDialog(BuildContext context) {
  return showWebDialog<void>(
    context: context,
    builder: (ctx) => BlocProvider.value(
      value: context.read<MissionsBloc>(),
      child: const PickMissionsDialog(),
    ),
  );
}

class PickMissionsDialog extends StatefulWidget {
  const PickMissionsDialog({super.key});

  @override
  State<PickMissionsDialog> createState() => _PickMissionsDialogState();
}

class _PickMissionsDialogState extends State<PickMissionsDialog> {
  var _filterIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<MissionsBloc>().add(const LoadPickToday());
  }

  List<MissionCardEntity> _filterOffers(List<MissionCardEntity> offers) {
    if (_filterIndex == 0) return offers;
    final diff = switch (_filterIndex) {
      1 => MissionDifficulty.hard,
      2 => MissionDifficulty.medium,
      _ => MissionDifficulty.easy,
    };
    return offers.where((o) => o.difficulty == diff).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560, maxHeight: 720),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: WebColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: WebColors.border),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Text(
                    l10n.pickMissionsTitle,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: WebColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: WebColors.textSecondary,
                      size: 20,
                    ),
                    tooltip: l10n.cancel,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WebFilterChips(
                labels: [
                  l10n.filterAll,
                  l10n.difficultyHard,
                  l10n.difficultyMedium,
                  l10n.difficultyEasy,
                ],
                selectedIndex: _filterIndex,
                onSelected: (i) => setState(() => _filterIndex = i),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<MissionsBloc, MissionsState>(
                builder: (context, state) {
                  return WebAnimatedSwitcher(
                    child: _buildPickBody(context, state, l10n),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickBody(
    BuildContext context,
    MissionsState state,
    AppLocalizations l10n,
  ) {
    if (state.pickStatus == MissionsLoadStatus.loading ||
        state.pickStatus == MissionsLoadStatus.initial) {
      return const WebPickMissionsSkeleton(
        key: ValueKey('pick-skeleton'),
      );
    }

    if (state.pickStatus == MissionsLoadStatus.error) {
      return Center(
        key: const ValueKey('pick-error'),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            state.pickError ?? l10n.errorLoadingOffers,
            textAlign: TextAlign.center,
            style: const TextStyle(color: WebColors.textSecondary),
          ),
        ),
      );
    }

    final pick = state.pick;
    if (pick == null) {
      return const SizedBox.shrink(key: ValueKey('pick-empty'));
    }

    final offers = _filterOffers(pick.offers);
    final acceptedIds = pick.offers
        .where((o) => o.status != MissionStatus.offer)
        .map((o) => o.offerId ?? o.id)
        .toSet();
    final canPickMore = canPickMoreMissions(pick);

    return Column(
      key: const ValueKey('pick-content'),
      children: [
        PickOffersHeader(pick: pick),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: offers.length,
            itemBuilder: (_, i) {
              final m = offers[i];
              final oid = m.offerId ?? m.id;
              final accepted = acceptedIds.contains(oid);
              final canAccept =
                  !accepted && canAcceptMissionOffer(m, pick);
              return WebAnimatedAppear(
                key: ValueKey('pick-offer-$oid'),
                staggerIndex: i,
                child: WebMissionPickCard(
                  mission: m,
                  accepted: accepted,
                  canAccept: canAccept,
                  onAccept: () {
                    context.read<MissionsBloc>().add(
                          AcceptMissionOffer(oid),
                        );
                    if (!canPickMore) {
                      Navigator.of(context).pop();
                    }
                  },
                  onReroll: () => _confirmReroll(context, l10n, oid),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _confirmReroll(
    BuildContext context,
    AppLocalizations l10n,
    String offerId,
  ) async {
    final ok = await showRerollMissionDialog(context);
    if (ok && context.mounted) {
      context.read<MissionsBloc>().add(RerollMissionOffer(offerId));
    }
  }
}
