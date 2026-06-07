import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';

Future<void> showWithdrawDialog(
  BuildContext context, {
  required int balance,
  required int minWithdrawWpgg,
}) {
  final walletBloc = context.read<WalletBloc>();

  return showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: true,
    builder: (ctx) => BlocProvider.value(
      value: walletBloc,
      child: _WithdrawDialog(
        balance: balance,
        minWithdrawWpgg: minWithdrawWpgg,
      ),
    ),
  );
}

class _WithdrawDialog extends StatefulWidget {
  const _WithdrawDialog({
    required this.balance,
    required this.minWithdrawWpgg,
  });

  final int balance;
  final int minWithdrawWpgg;

  @override
  State<_WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<_WithdrawDialog> {
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.balance >= widget.minWithdrawWpgg
        ? widget.balance.toString()
        : widget.minWithdrawWpgg.toString();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String _normalizeAddress(String raw) {
    final trimmed = raw.trim();
    if (RegExp(r'^0x[0-9a-fA-F]{40}$').hasMatch(trimmed)) {
      return trimmed;
    }
    if (RegExp(r'^[0-9a-fA-F]{40}$').hasMatch(trimmed)) {
      return '0x$trimmed';
    }
    return trimmed;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final amount = int.parse(_amountController.text.trim());
    context.read<WalletBloc>().add(
          RequestWithdrawal(
            walletAddress: _normalizeAddress(_addressController.text),
            amountWpgg: amount,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return BlocListener<WalletBloc, WalletState>(
      listenWhen: (prev, curr) =>
          curr is WalletWithdrawSuccess || curr is WalletWithdrawError,
      listener: (context, state) {
        Navigator.of(context).pop();
      },
      child: BlocBuilder<WalletBloc, WalletState>(
        buildWhen: (prev, curr) =>
            prev is WalletWithdrawing != curr is WalletWithdrawing,
        builder: (context, state) {
          final isSubmitting = state is WalletWithdrawing;

          return Dialog(
            backgroundColor: WpggBrand.cardSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: const EdgeInsets.symmetric(horizontal: 28),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 20, 16, 24 + bottomInset),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.withdrawTitle,
                                style: const TextStyle(
                                  fontFamily: AppFonts.lexendDeca,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: WpggBrand.cardTextDark,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.withdrawMinHint(widget.minWithdrawWpgg),
                                style: TextStyle(
                                  fontFamily: AppFonts.lexendDeca,
                                  color: Colors.black.withValues(alpha: 0.55),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: isSubmitting
                              ? null
                              : () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.close,
                            color: WpggBrand.cardTextDark,
                            size: 22,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _addressController,
                      enabled: !isSubmitting,
                      decoration: InputDecoration(
                        labelText: l10n.walletAddressLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final normalized = _normalizeAddress(value ?? '');
                        if (normalized.isEmpty) {
                          return l10n.walletAddressRequired;
                        }
                        if (!RegExp(r'^0x[0-9a-fA-F]{40}$')
                            .hasMatch(normalized)) {
                          return l10n.walletAddressInvalid;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      enabled: !isSubmitting,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.withdrawAmountLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final parsed = int.tryParse(value?.trim() ?? '');
                        if (parsed == null) {
                          return l10n.withdrawAmountInvalid;
                        }
                        if (parsed < widget.minWithdrawWpgg) {
                          return l10n.withdrawMinHint(widget.minWithdrawWpgg);
                        }
                        if (parsed > widget.balance) {
                          return l10n.withdrawInsufficientBalance;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    WpggPrimaryButton(
                      label: l10n.withdraw,
                      isLoading: isSubmitting,
                      onPressed: widget.balance >= widget.minWithdrawWpgg &&
                              !isSubmitting
                          ? _submit
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
