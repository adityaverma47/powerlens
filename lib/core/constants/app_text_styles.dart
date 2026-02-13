import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography: Inter, heading w500, subheading/body w400, small w300.
abstract class AppTextStyles {
  static TextStyle get heading => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        fontSize: 20,
      );

  static TextStyle get subheading => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        fontSize: 16,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        fontSize: 14,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontWeight: FontWeight.w300,
        color: AppColors.textSecondary,
        fontSize: 12,
      );

  static TextStyle get batteryPercentage => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        fontSize: 46,
      );

  static TextStyle get statusChip => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 14,
      );
}
