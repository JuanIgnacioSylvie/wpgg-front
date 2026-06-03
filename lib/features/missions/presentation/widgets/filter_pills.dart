import 'package:flutter/material.dart';

import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';

class FilterPills extends StatelessWidget {
  const FilterPills({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: WpggPrimaryButton.height + WpggButtonShadow.layoutPaddingBottom,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: labels.length,
        itemBuilder: (_, i) {
          final selected = i == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(
              right: i == labels.length - 1 ? 0 : 8,
            ),
            child: _FilterPillButton(
              label: labels[i],
              selected: selected,
              onTap: () => onSelected(i),
            ),
          );
        },
      ),
    );
  }
}

class _FilterPillButton extends StatelessWidget {
  const _FilterPillButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: WpggButtonShadow.layoutPaddingBottom),
      child: SizedBox(
        height: WpggPrimaryButton.height,
        child: CustomPaint(
          painter: _FilterPillPainter(
            fillColor: selected ? AuthUiColors.accentRed : Colors.white,
            borderColor: selected ? null : AuthUiColors.accentRed,
            borderWidth: selected ? 0 : 1.5,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AuthUiColors.accentRed,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterPillPainter extends CustomPainter {
  _FilterPillPainter({
    required this.fillColor,
    this.borderColor,
    this.borderWidth = 0,
  });

  final Color fillColor;
  final Color? borderColor;
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final path = wpggBulgeButtonPath(size);
    paintWpggBulgeDropShadow(canvas, path);
    canvas.drawPath(path, Paint()..color = fillColor);
    if (borderColor != null && borderWidth > 0) {
      canvas.drawPath(
        path,
        Paint()
          ..color = borderColor!
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FilterPillPainter old) =>
      old.fillColor != fillColor ||
      old.borderColor != borderColor ||
      old.borderWidth != borderWidth;
}
