import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/bloc/home_bloc.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/widgets/build_app_bar.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/widgets/build_news_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load default news on start
    BlocProvider.of<HomeBloc>(context).add(LoadNewsEvent('technology'));
  }

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            buildAppBar(context, queryController),
            buildNewsContent(queryController),
          ],
        ),
      ),
    );
  }
}
