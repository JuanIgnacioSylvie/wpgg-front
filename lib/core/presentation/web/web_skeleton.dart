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
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _WebShimmerInherited(
      animation: _controller,
      child: widget.child,
    );
  }
}

class _WebShimmerInherited extends InheritedWidget {
  const _WebShimmerInherited({
    required this.animation,
    required super.child,
  });

  final Animation<double> animation;

  static Animation<double> of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_WebShimmerInherited>();
    assert(scope != null, 'WebShimmerScope not found in widget tree');
    return scope!.animation;
  }

  @override
  bool updateShouldNotify(_WebShimmerInherited oldWidget) =>
      oldWidget.animation != animation;
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

  @override
  Widget build(BuildContext context) {
    final shimmer = _WebShimmerInherited.of(context).value;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment(-1.5 + shimmer * 3, 0),
          end: Alignment(-0.5 + shimmer * 3, 0),
          colors: const [
            WebColors.surface,
            WebColors.surfaceElevated,
            WebColors.surface,
          ],
          stops: const [0.25, 0.5, 0.75],
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
                  children: const [
                    WebSkeletonBox(width: double.infinity, height: 14),
                    SizedBox(height: 8),
                    WebSkeletonBox(width: 72, height: 10),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const WebSkeletonBox(width: 120, height: 10),
          const SizedBox(height: 12),
          const WebSkeletonBox(
            width: double.infinity,
            height: 4,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 8),
          const WebSkeletonBox(width: 36, height: 10),
        ],
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
            Row(
              children: const [
                WebSkeletonBox(width: 110, height: 16),
                SizedBox(width: 8),
                WebSkeletonBox(
                  width: 24,
                  height: 20,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: const [
                WebMissionCardSkeleton(),
                WebMissionCardSkeleton(),
                WebMissionCardSkeleton(),
              ],
            ),
            const SizedBox(height: 48),
            const WebSkeletonBox(width: 130, height: 16),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: const [
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
            children: const [
              Row(
                children: [
                  WebSkeletonBox(width: 80, height: 12),
                  Spacer(),
                  WebSkeletonBox(width: 48, height: 12),
                ],
              ),
              SizedBox(height: 12),
              WebSkeletonBox(width: double.infinity, height: 14),
              SizedBox(height: 8),
              WebSkeletonBox(width: 200, height: 14),
              SizedBox(height: 16),
              WebSkeletonBox(
                width: double.infinity,
                height: 40,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
