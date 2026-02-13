import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// App theme: background #F7F8FA, cards white, primary gradient, Inter.
abstract class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryStart,
          secondary: AppColors.primaryEnd,
          surface: AppColors.cardBackground,
          error: AppColors.accentRed,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.textPrimary,
          onError: Colors.white,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        cardTheme: CardThemeData(
  color: AppColors.cardBackground,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
      );
}
