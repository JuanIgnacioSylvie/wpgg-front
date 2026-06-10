import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/missions/presentation/bloc/missions_bloc.dart';
import '../../features/store/presentation/bloc/store_bloc.dart';
import '../../features/store/presentation/widgets/store_purchase_dialog.dart';
import '../../features/store/presentation/widgets/store_purchase_success_dialog.dart';
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
  var _storePurchaseOverlayVisible = false;

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

  void _hideOverlayIfIdle() {
    if (_visibleAction == null && !_storePurchaseOverlayVisible) {
      WpggTransactionOverlay.hide();
    }
  }

  void _syncMissionOverlay(MissionActionType? actionInProgress) {
    if (actionInProgress == _visibleAction) {
      return;
    }
    _visibleAction = actionInProgress;
    if (actionInProgress == null) {
      _hideOverlayIfIdle();
      return;
    }
    WpggTransactionOverlay.show(
      context,
      message: _processingMessage(actionInProgress),
    );
  }

  void _syncStorePurchaseOverlay(bool purchasing) {
    if (purchasing == _storePurchaseOverlayVisible) {
      return;
    }
    _storePurchaseOverlayVisible = purchasing;
    if (!purchasing) {
      _hideOverlayIfIdle();
      return;
    }
    WpggTransactionOverlay.show(
      context,
      message: context.l10n.transactionProcessingPurchase,
    );
  }

  void _handleMissionFeedback(MissionActionFeedback feedback) {
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

  void _handleStorePurchaseResult(StoreLoaded state) {
    final error = state.purchaseError;
    if (error != null) {
      _syncStorePurchaseOverlay(false);
      WpggSnackBar.show(
        context,
        friendlyStorePurchaseError(error, context.l10n),
        isError: true,
      );
      context.read<StoreBloc>().add(const ClearStorePurchaseResult());
      return;
    }

    final purchase = state.lastPurchase;
    if (purchase == null) {
      return;
    }

    _syncStorePurchaseOverlay(false);
    context.read<StoreBloc>().add(const ClearStorePurchaseResult());
    unawaited(showStorePurchaseSuccessDialog(context, purchase));
  }

  bool _storeResultChanged(StoreState previous, StoreState current) {
    final prev = previous is StoreLoaded ? previous : null;
    final curr = current is StoreLoaded ? current : null;
    return prev?.purchasing != curr?.purchasing ||
        prev?.purchaseError != curr?.purchaseError ||
        prev?.lastPurchase != curr?.lastPurchase;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MissionsBloc, MissionsState>(
          listenWhen: (previous, current) =>
              previous.actionInProgress != current.actionInProgress ||
              previous.actionFeedback != current.actionFeedback,
          listener: (context, state) {
            _syncMissionOverlay(state.actionInProgress);
            final feedback = state.actionFeedback;
            if (feedback != null) {
              _handleMissionFeedback(feedback);
              context
                  .read<MissionsBloc>()
                  .add(const ClearMissionActionFeedback());
            }
          },
        ),
        BlocListener<StoreBloc, StoreState>(
          listenWhen: _storeResultChanged,
          listener: (context, state) {
            if (state is! StoreLoaded) {
              return;
            }
            _syncStorePurchaseOverlay(state.purchasing);
            if (state.purchaseError != null || state.lastPurchase != null) {
              _handleStorePurchaseResult(state);
            }
          },
        ),
      ],
      child: widget.child,
    );
  }
}
