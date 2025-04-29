import 'package:flutter/material.dart';
import 'package:admin_booking_application/theme/app_colors.dart';

class Styles {
  static ThemeData themeData(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.lightScaffoldColor,
      cardColor: AppColors.lightCardColor,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8742CD),
        primary: const Color(0xFF8742CD),
        secondary: const Color(0xFFEEDC13),
        error: const Color(0xFFE53935),
        brightness: Brightness.light,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding: const EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme
                .of(context)
                .colorScheme
                .error,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme
                .of(context)
                .colorScheme
                .error,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}
