import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../locale/locale_provider.dart';
import '../../../features/ddragon/presentation/providers/ddragon_provider.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../features/riot/presentation/bloc/riot_bloc.dart';
import '../../../features/wallet/presentation/bloc/wallet_bloc.dart';
import 'web_colors.dart';

Future<void> showWebProfileDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    builder: (ctx) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<RiotBloc>()),
        BlocProvider.value(value: context.read<WalletBloc>()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: context.read<DDragonProvider>(),
          ),
          ChangeNotifierProvider.value(
            value: context.read<LocaleProvider>(),
          ),
        ],
        child: const _WebProfileDialog(),
      ),
    ),
  );
}

class _WebProfileDialog extends StatelessWidget {
  const _WebProfileDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440, maxHeight: 720),
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ProfilePage(
              embeddedInPanel: true,
              onClose: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
    );
  }
}
