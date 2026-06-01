import 'package:flutter/material.dart';

import '../../../../core/constants/wpgg_brand.dart';

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
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: labels.length,
        itemBuilder: (_, i) {
          final selected = i == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(labels[i]),
              selected: selected,
              onSelected: (_) => onSelected(i),
              selectedColor: WpggBrand.primary,
              labelStyle: TextStyle(
                color: selected ? WpggBrand.white : WpggBrand.primary,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: WpggBrand.cardSurface,
              side: BorderSide(
                color: selected ? WpggBrand.primary : WpggBrand.primary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}
