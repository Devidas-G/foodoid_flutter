import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodoid/core/theme/app_theme.dart';
import 'package:foodoid/features/home/presentation/pages/home_page.dart';
import 'dependency_injection.dart' as di;
import 'features/home/presentation/bloc/home_bloc.dart';

/// This widget is the root of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      title: 'Foodoid',
      home: BlocProvider(
        create: (context) => di.sl<HomeBloc>(),
        child: const HomePage(),
      ),
    );
  }
}