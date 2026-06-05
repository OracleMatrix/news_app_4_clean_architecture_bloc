import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_4_clean_architecture_bloc/core/router/app_pages.dart';
import 'package:news_app_4_clean_architecture_bloc/di.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/bloc/home_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider<HomeBloc>(create: (context) => di<HomeBloc>())],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: "News App",
        routerConfig: router,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
      ),
    ),
  );
}
