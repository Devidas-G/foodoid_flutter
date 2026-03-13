import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppDarkColors.background,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,

      primary: AppDarkColors.primary,
      onPrimary: AppDarkColors.textPrimary,

      secondary: AppDarkColors.accent,
      onSecondary: AppDarkColors.textPrimary,

      error: AppDarkColors.error,
      onError: AppDarkColors.textPrimary,

      background: AppDarkColors.background,
      onBackground: AppDarkColors.textPrimary,

      surface: AppDarkColors.surface,
      onSurface: AppDarkColors.textPrimary,
    ),

    cardColor: AppDarkColors.elevatedSurface,

    dividerColor: AppDarkColors.border,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppDarkColors.background,
      foregroundColor: AppDarkColors.textPrimary,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppDarkColors.primary,
        foregroundColor: AppDarkColors.textPrimary,
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppDarkColors.textPrimary),
      bodyMedium: TextStyle(color: AppDarkColors.textSecondary),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppDarkColors.elevatedSurface,
      hintStyle: TextStyle(color: AppDarkColors.textSecondary),
      labelStyle: TextStyle(color: AppDarkColors.textPrimary),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppDarkColors.border),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppDarkColors.border),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppDarkColors.primary),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppDarkColors.error),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppDarkColors.textPrimary,
        // side: const BorderSide(color: AppDarkColors.primary),
      ),
    ),
  );

  // Temporary simple light theme (you can refine later)
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: AppDarkColors.primary),
  );
}
