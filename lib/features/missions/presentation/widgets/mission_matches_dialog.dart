import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/mission_card_l10n.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/network/network_error_message.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_shell_scope.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../../riot/presentation/widgets/match_tile.dart';
import '../../data/datasources/missions_remote_datasource.dart';
import '../../domain/entities/mission_card_entity.dart';
import '../../domain/entities/mission_match_entity.dart';

Future<void> showMissionMatchesDialog(
  BuildContext context,
  MissionCardEntity mission,
) {
  if (mission.status == MissionStatus.offer) {
    return Future.value();
  }

  final child = MissionMatchesPanel(mission: mission);

  if (WebShellScope.isActive(context)) {
    return showWebDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: WebColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: WebColors.border),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480, maxHeight: 640),
          child: child,
        ),
      ),
    );
  }

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(ctx).bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (_, scrollController) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A2E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: MissionMatchesPanel(
              mission: mission,
              scrollController: scrollController,
            ),
          );
        },
      ),
    ),
  );
}

class MissionMatchesPanel extends StatefulWidget {
  const MissionMatchesPanel({
    super.key,
    required this.mission,
    this.scrollController,
  });

  final MissionCardEntity mission;
  final ScrollController? scrollController;

  @override
  State<MissionMatchesPanel> createState() => _MissionMatchesPanelState();
}

class _MissionMatchesPanelState extends State<MissionMatchesPanel> {
  var _loading = true;
  String? _error;
  List<MissionMatchEntity> _matches = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final matches = await sl<MissionsRemoteDataSource>().fetchMissionMatches(
        widget.mission.id,
      );
      if (!mounted) return;
      setState(() {
        _matches = matches;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = networkErrorMessage(e);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isWeb = WebShellScope.isActive(context);
    final titleColor =
        isWeb ? WebColors.textPrimary : Colors.white;
    final mutedColor =
        isWeb ? WebColors.textMuted : Colors.white60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.missionMatchesTitle,
                      style: TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        color: titleColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.mission.localizedTitle(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: mutedColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close, color: mutedColor),
              ),
            ],
          ),
        ),
        if (!_loading && _error == null && _matches.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: _Legend(isWeb: isWeb),
          ),
        Expanded(child: _buildBody(isWeb, mutedColor)),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: WpggPrimaryButton(
              onPressed: _load,
              label: l10n.retry,
            ),
          ),
      ],
    );
  }

  Widget _buildBody(bool isWeb, Color mutedColor) {
    final l10n = context.l10n;

    if (_loading) {
      return Center(
        child: CircularProgressIndicator(
          color: isWeb ? WebColors.accent : Colors.white,
          strokeWidth: 2.5,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: mutedColor, fontSize: 14),
          ),
        ),
      );
    }

    if (_matches.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.missionMatchesEmpty,
            textAlign: TextAlign.center,
            style: TextStyle(color: mutedColor, fontSize: 14),
          ),
        ),
      );
    }

    return ListView.separated(
      controller: widget.scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      itemCount: _matches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final match = _matches[index];
        return MatchTile(
          match: match,
          contribution: match.contribution,
          useWebStyle: isWeb,
        );
      },
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.isWeb});

  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        _LegendItem(
          color: const Color(0xFF2E7D52),
          label: l10n.missionMatchesLegendContributed,
          isWeb: isWeb,
        ),
        _LegendItem(
          color: isWeb ? WebColors.textMuted : Colors.white38,
          label: l10n.missionMatchesLegendNoProgress,
          isWeb: isWeb,
        ),
        _LegendItem(
          color: isWeb ? WebColors.border : Colors.white24,
          label: l10n.missionMatchesLegendNotEligible,
          isWeb: isWeb,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.isWeb,
  });

  final Color color;
  final String label;
  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: isWeb ? WebColors.textSecondary : Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
