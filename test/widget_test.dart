import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wpgg_flutter/core/constants/app_colors.dart';

void main() {
  test('AppColors darkPrimary matches spec', () {
    expect(AppColors.darkPrimary, const Color(0xFF7C4DFF));
  });
}
