import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_skeleton.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../../../core/utils/mission_day.dart';
import '../../domain/entities/mission_card_entity.dart';
import '../bloc/missions_bloc.dart';
import 'day_carousel.dart';
import 'filter_pills.dart';
import 'mission_pick_card.dart';

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
  final _selectedDate = MissionDay.todayUtc();

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

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 720),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: WebColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: WebColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
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
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: WebColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              DayCarousel(
                selectedDate: _selectedDate,
                onDateSelected: (_) {},
                lockToToday: true,
              ),
              const SizedBox(height: 12),
              FilterPills(
                labels: [
                  l10n.filterAll,
                  l10n.difficultyHard,
                  l10n.difficultyMedium,
                  l10n.difficultyEasy,
                ],
                selectedIndex: _filterIndex,
                onSelected: (i) => setState(() => _filterIndex = i),
              ),
              Expanded(
                child: BlocConsumer<MissionsBloc, MissionsState>(
                  listener: (context, state) {
                    if (state.pickError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.pickError!)),
                      );
                    }
                  },
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
    final canPickMore = pick.selectedCount < pick.maxSelectable;

    return Column(
      key: const ValueKey('pick-content'),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.selectedMissionsCount(
              pick.selectedCount,
              pick.maxSelectable,
              pick.maxHard,
            ),
            style: const TextStyle(color: WebColors.textMuted),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: offers.length,
            itemBuilder: (_, i) {
              final m = offers[i];
              final oid = m.offerId ?? m.id;
              final accepted = acceptedIds.contains(oid);
              return WebAnimatedAppear(
                key: ValueKey('pick-offer-$oid'),
                staggerIndex: i,
                child: MissionPickCard(
                  mission: m,
                  accepted: accepted,
                  onAccept: () {
                    context.read<MissionsBloc>().add(
                          AcceptMissionOffer(oid),
                        );
                    context.read<MissionsBloc>().add(
                          const LoadMissionsHome(),
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
    final ok = await showWebDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: WebColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: WebColors.border),
        ),
        title: Text(
          l10n.rerollMissionTitle,
          style: const TextStyle(color: WebColors.textPrimary),
        ),
        content: Text(
          l10n.rerollMissionBody,
          style: const TextStyle(color: WebColors.textSecondary),
        ),
        actions: [
          WpggCancelButton(
            onPressed: () => Navigator.pop(ctx, false),
            label: l10n.cancel,
          ),
          WpggPrimaryButton(
            onPressed: () => Navigator.pop(ctx, true),
            label: l10n.reroll,
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<MissionsBloc>().add(RerollMissionOffer(offerId));
    }
  }
}
