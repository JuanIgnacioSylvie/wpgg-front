import 'package:flutter/material.dart';

EdgeInsets leaderboardPagePadding(BuildContext context, {bool useWeb = true}) {
  final width = MediaQuery.sizeOf(context).width;
  if (!useWeb) {
    return const EdgeInsets.fromLTRB(16, 16, 16, 100);
  }
  if (width < 600) {
    return const EdgeInsets.fromLTRB(16, 20, 16, 120);
  }
  if (width < 960) {
    return const EdgeInsets.fromLTRB(24, 28, 24, 120);
  }
  return const EdgeInsets.fromLTRB(32, 32, 32, 120);
}

bool leaderboardIsCompact(BuildContext context) {
  return MediaQuery.sizeOf(context).width < 720;
}

bool leaderboardIsNarrowRow(BuildContext context) {
  return MediaQuery.sizeOf(context).width < 860;
}
