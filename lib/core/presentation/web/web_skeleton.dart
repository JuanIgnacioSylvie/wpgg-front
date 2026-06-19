import 'package:flutter/material.dart';

import 'web_colors.dart';

/// Shimmer animation shared by skeleton placeholders on web.
class WebShimmerScope extends StatefulWidget {
  const WebShimmerScope({super.key, required this.child});

  final Widget child;

  @override
  State<WebShimmerScope> createState() => _WebShimmerScopeState();
}

class _WebShimmerScopeState extends State<WebShimmerScope>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return _WebShimmerInherited(
          shimmer: _controller.value,
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}

class _WebShimmerInherited extends InheritedWidget {
  const _WebShimmerInherited({
    required this.shimmer,
    required super.child,
  });

  final double shimmer;

  static double of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_WebShimmerInherited>();
    assert(scope != null, 'WebShimmerScope not found in widget tree');
    return scope!.shimmer;
  }

  @override
  bool updateShouldNotify(_WebShimmerInherited oldWidget) =>
      oldWidget.shimmer != shimmer;
}

class WebSkeletonBox extends StatelessWidget {
  const WebSkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  final double width;
  final double height;
  final BorderRadius borderRadius;

  static const _base = Color(0xFF18181F);
  static const _highlight = Color(0xFF2E2E3A);

  @override
  Widget build(BuildContext context) {
    final shimmer = _WebShimmerInherited.of(context);
    final slide = -1.2 + shimmer * 2.4;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment(slide - 0.6, 0),
          end: Alignment(slide + 0.6, 0),
          colors: const [_base, _highlight, _base],
          stops: const [0.35, 0.5, 0.65],
        ),
      ),
    );
  }
}

class WebMissionCardSkeleton extends StatelessWidget {
  const WebMissionCardSkeleton({super.key});

  static const double cardWidth = 280;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WebColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WebColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              WebSkeletonBox(
                width: 36,
                height: 36,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WebSkeletonBox(width: double.infinity, height: 14),
                    const SizedBox(height: 8),
                    WebSkeletonBox(width: 72, height: 10),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          WebSkeletonBox(width: 120, height: 10),
          const SizedBox(height: 12),
          WebSkeletonBox(
            width: double.infinity,
            height: 4,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          WebSkeletonBox(width: 36, height: 10),
        ],
      ),
    );
  }
}

class ProfileBalanceCardSkeleton extends StatelessWidget {
  const ProfileBalanceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: WebColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: WebColors.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: WebColors.accent.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            WebSkeletonBox(
              width: 28,
              height: 28,
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                WebSkeletonBox(width: 52, height: 12),
                SizedBox(height: 6),
                WebSkeletonBox(width: 100, height: 20),
                SizedBox(height: 4),
                WebSkeletonBox(width: 72, height: 13),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WebDashboardSkeleton extends StatelessWidget {
  const WebDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return WebShimmerScope(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileBalanceCardSkeleton(),
            const SizedBox(height: 24),
            Row(
              children: [
                WebSkeletonBox(width: 110, height: 16),
                const SizedBox(width: 8),
                WebSkeletonBox(
                  width: 24,
                  height: 20,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                WebMissionCardSkeleton(),
                WebMissionCardSkeleton(),
                WebMissionCardSkeleton(),
              ],
            ),
            const SizedBox(height: 48),
            WebSkeletonBox(width: 130, height: 16),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                WebMissionCardSkeleton(),
                WebMissionCardSkeleton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key, this.useWebStyle = true});

  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final avatarSize = useWebStyle ? 80.0 : 112.0;
    final cardRadius = useWebStyle ? 12.0 : 20.0;
    final pillRadius = BorderRadius.circular(useWebStyle ? 12 : 28);

    return WebShimmerScope(
      child: Column(
        children: [
          if (useWebStyle) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              child: Column(
                children: [
                  WebSkeletonBox(
                    width: avatarSize,
                    height: avatarSize,
                    borderRadius: BorderRadius.circular(avatarSize / 2),
                  ),
                  const SizedBox(height: 12),
                  const WebSkeletonBox(width: 140, height: 18),
                  const SizedBox(height: 6),
                  const WebSkeletonBox(width: 72, height: 13),
                ],
              ),
            ),
          ] else ...[
            SizedBox(
              height: 200,
              child: Center(
                child: WebSkeletonBox(
                  width: avatarSize,
                  height: avatarSize,
                  borderRadius: BorderRadius.circular(avatarSize / 2),
                ),
              ),
            ),
            const WebSkeletonBox(width: 140, height: 18),
            const SizedBox(height: 20),
          ],
          Row(
            children: [
              Expanded(
                child: WebSkeletonBox(
                  width: double.infinity,
                  height: useWebStyle ? 52 : 48,
                  borderRadius: pillRadius,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WebSkeletonBox(
                  width: double.infinity,
                  height: useWebStyle ? 52 : 48,
                  borderRadius: pillRadius,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _ProfileSettingsCardSkeleton(
            rowCount: 2,
            borderRadius: cardRadius,
            useWebStyle: useWebStyle,
          ),
          const SizedBox(height: 16),
          _ProfileSettingsCardSkeleton(
            rowCount: 4,
            borderRadius: cardRadius,
            useWebStyle: useWebStyle,
          ),
        ],
      ),
    );
  }
}

class _ProfileSettingsCardSkeleton extends StatelessWidget {
  const _ProfileSettingsCardSkeleton({
    required this.rowCount,
    required this.borderRadius,
    required this.useWebStyle,
  });

  final int rowCount;
  final double borderRadius;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: useWebStyle ? WebColors.surfaceElevated : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(borderRadius),
        border: useWebStyle
            ? Border.all(color: WebColors.borderSubtle)
            : null,
      ),
      child: Column(
        children: [
          for (var i = 0; i < rowCount; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                color: useWebStyle ? WebColors.borderSubtle : const Color(0xFFE8E8ED),
              ),
            const _ProfileSettingsRowSkeleton(),
          ],
        ],
      ),
    );
  }
}

class _ProfileSettingsRowSkeleton extends StatelessWidget {
  const _ProfileSettingsRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: const [
          WebSkeletonBox(
            width: 24,
            height: 24,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: WebSkeletonBox(width: double.infinity, height: 14),
          ),
          SizedBox(width: 12),
          WebSkeletonBox(width: 44, height: 20),
        ],
      ),
    );
  }
}

class LeaderboardSkeleton extends StatelessWidget {
  const LeaderboardSkeleton({super.key, this.rowCount = 8});

  final int rowCount;

  @override
  Widget build(BuildContext context) {
    return WebShimmerScope(
      child: Column(
        children: [
          for (var i = 0; i < rowCount; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            const _LeaderboardRowSkeleton(),
          ],
        ],
      ),
    );
  }
}

class _LeaderboardRowSkeleton extends StatelessWidget {
  const _LeaderboardRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: WebColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WebColors.borderSubtle),
      ),
      child: Row(
        children: const [
          WebSkeletonBox(
            width: 32,
            height: 32,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          SizedBox(width: 14),
          WebSkeletonBox(
            width: 40,
            height: 40,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WebSkeletonBox(width: 120, height: 14),
                SizedBox(height: 6),
                WebSkeletonBox(width: 64, height: 11),
              ],
            ),
          ),
          SizedBox(width: 12),
          WebSkeletonBox(
            width: 72,
            height: 28,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ],
      ),
    );
  }
}

class WebPickMissionsSkeleton extends StatelessWidget {
  const WebPickMissionsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return WebShimmerScope(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: WebColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: WebColors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  WebSkeletonBox(width: 80, height: 12),
                  const Spacer(),
                  WebSkeletonBox(width: 48, height: 12),
                ],
              ),
              const SizedBox(height: 12),
              WebSkeletonBox(width: double.infinity, height: 14),
              const SizedBox(height: 8),
              WebSkeletonBox(width: 200, height: 14),
              const SizedBox(height: 16),
              WebSkeletonBox(
                width: double.infinity,
                height: 40,
                borderRadius: BorderRadius.circular(20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
