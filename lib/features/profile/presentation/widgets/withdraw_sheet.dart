import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';

Future<void> showWithdrawSheet(
  BuildContext context, {
  required int balance,
  required int minWithdrawWpgg,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: WpggBrand.cardSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _WithdrawSheet(
      balance: balance,
      minWithdrawWpgg: minWithdrawWpgg,
    ),
  );
}

class _WithdrawSheet extends StatefulWidget {
  const _WithdrawSheet({
    required this.balance,
    required this.minWithdrawWpgg,
  });

  final int balance;
  final int minWithdrawWpgg;

  @override
  State<_WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends State<_WithdrawSheet> {
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

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final amount = int.parse(_amountController.text.trim());
    context.read<WalletBloc>().add(
          RequestWithdrawal(
            walletAddress: _addressController.text.trim(),
            amountWpgg: amount,
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.withdrawTitle,
              style: const TextStyle(
                fontFamily: AppFonts.lexendDeca,
                fontSize: 20,
                fontWeight: FontWeight.w700,
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
            const SizedBox(height: 20),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: l10n.walletAddressLabel,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                final v = value?.trim() ?? '';
                if (v.isEmpty) {
                  return l10n.walletAddressRequired;
                }
                if (!RegExp(r'^0x[0-9a-fA-F]{40}$').hasMatch(v)) {
                  return l10n.walletAddressInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
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
            FilledButton(
              onPressed: widget.balance >= widget.minWithdrawWpgg ? _submit : null,
              style: FilledButton.styleFrom(
                backgroundColor: WpggBrand.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                l10n.withdraw,
                style: const TextStyle(
                  fontFamily: AppFonts.lexendDeca,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
