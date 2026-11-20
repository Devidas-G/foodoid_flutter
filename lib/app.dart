import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodoid/core/theme/app_theme.dart';
import 'package:foodoid/features/giveaway/presentation/bloc/giveaway_bloc.dart';
import 'package:foodoid/features/home/presentation/pages/home_page.dart';
import 'dependency_injection.dart';
import 'features/home/presentation/bloc/home_bloc.dart';

/// This widget is the root of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //do not use BlocProvider(create:...) for auth bloc as it is already regestered in di,
        //else you’ll have two separate AuthBloc instances.
        BlocProvider(
          create: (context) => sl<HomeBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<GiveawayBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        title: 'Foodoid',
        home: const HomePage(),
      ),
    );
  }
}
