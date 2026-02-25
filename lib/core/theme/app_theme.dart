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
      );

  // Temporary simple light theme (you can refine later)
  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppDarkColors.primary,
        ),
      );
}