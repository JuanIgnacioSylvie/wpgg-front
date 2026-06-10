import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/missions/presentation/bloc/missions_bloc.dart';
import '../l10n/l10n_extension.dart';
import 'wpgg_snackbar.dart';
import 'wpgg_transaction_overlay.dart';

/// Listens to transactional blocs and shows loading overlay + result snackbars.
class WpggTransactionFeedbackHost extends StatefulWidget {
  const WpggTransactionFeedbackHost({super.key, required this.child});

  final Widget child;

  @override
  State<WpggTransactionFeedbackHost> createState() =>
      _WpggTransactionFeedbackHostState();
}

class _WpggTransactionFeedbackHostState
    extends State<WpggTransactionFeedbackHost> {
  MissionActionType? _visibleAction;

  @override
  void dispose() {
    WpggTransactionOverlay.hide();
    super.dispose();
  }

  String _processingMessage(MissionActionType type) {
    final l10n = context.l10n;
    return switch (type) {
      MissionActionType.accept => l10n.transactionProcessingAcceptMission,
      MissionActionType.reroll => l10n.transactionProcessingRerollMission,
      MissionActionType.cancel => l10n.transactionProcessingCancelMission,
    };
  }

  String _successMessage(MissionActionFeedback feedback) {
    final l10n = context.l10n;
    return switch (feedback.type) {
      MissionActionType.accept => l10n.transactionSuccessAcceptMission,
      MissionActionType.reroll => l10n.transactionSuccessRerollMission,
      MissionActionType.cancel => l10n.transactionSuccessCancelMission,
    };
  }

  void _syncOverlay(MissionActionType? actionInProgress) {
    if (actionInProgress == _visibleAction) {
      return;
    }
    _visibleAction = actionInProgress;
    if (actionInProgress == null) {
      WpggTransactionOverlay.hide();
      return;
    }
    WpggTransactionOverlay.show(
      context,
      message: _processingMessage(actionInProgress),
    );
  }

  void _handleFeedback(MissionActionFeedback feedback) {
    final l10n = context.l10n;
    if (feedback.success) {
      WpggSnackBar.show(context, _successMessage(feedback));
      return;
    }
    WpggSnackBar.show(
      context,
      feedback.message ?? l10n.transactionFailedGeneric,
      isError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MissionsBloc, MissionsState>(
      listenWhen: (previous, current) =>
          previous.actionInProgress != current.actionInProgress ||
          previous.actionFeedback != current.actionFeedback,
      listener: (context, state) {
        _syncOverlay(state.actionInProgress);
        final feedback = state.actionFeedback;
        if (feedback != null) {
          _handleFeedback(feedback);
          context.read<MissionsBloc>().add(const ClearMissionActionFeedback());
        }
      },
      child: widget.child,
    );
  }
}
