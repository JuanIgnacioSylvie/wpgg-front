import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../bloc/riot_bloc.dart';
import '../bloc/riot_event.dart';

void showRiotLinkSheet(BuildContext context) {
  final gameName = TextEditingController();
  final tagLine = TextEditingController();
  final region = TextEditingController(text: AppConstants.riotDefaultRegion);

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      final l10n = ctx.l10n;
      return Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.linkRiotSheetTitle,
              style: Theme.of(ctx).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: gameName,
              decoration: InputDecoration(labelText: l10n.summonerNameLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tagLine,
              decoration: InputDecoration(labelText: l10n.tagLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: region,
              decoration: InputDecoration(labelText: l10n.regionLabel),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                context.read<RiotBloc>().add(
                      LinkRiotAccount(
                        gameName: gameName.text.trim(),
                        tagLine: tagLine.text.trim(),
                        region: region.text.trim(),
                      ),
                    );
                Navigator.pop(ctx);
              },
              child: Text(l10n.linkRiotSheetAction),
            ),
          ],
        ),
      );
    },
  );
}
