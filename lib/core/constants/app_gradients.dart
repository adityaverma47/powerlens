import 'package:flutter/material.dart';
import 'app_colors.dart';

/// App gradient definitions (primary: #1D2671 → #C33764).
abstract class AppGradients {
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primaryStart, AppColors.primaryEnd],
  );

  static const LinearGradient primaryVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primaryStart, AppColors.primaryEnd],
  );
}
