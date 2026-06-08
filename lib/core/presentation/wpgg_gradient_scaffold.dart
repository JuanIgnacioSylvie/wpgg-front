import 'package:flutter/material.dart';

import '../constants/wpgg_brand.dart';
import 'web/web_colors.dart';
import 'web/web_shell_scope.dart';

class WpggGradientScaffold extends StatelessWidget {
  const WpggGradientScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    if (WebShellScope.isActive(context)) {
      return ColoredBox(
        color: WebColors.background,
        child: body,
      );
    }

    return Container(
      decoration: const BoxDecoration(gradient: WpggBrand.scaffoldGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }
}
