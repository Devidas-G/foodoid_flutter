import 'package:flutter/material.dart';
import 'package:foodoid/core/theme/app_theme.dart';
import 'package:foodoid/features/home/presentation/pages/home_page.dart';
/// This widget is the root of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      title: 'Foodoid',
      home: HomePage(),
    );
  }
}