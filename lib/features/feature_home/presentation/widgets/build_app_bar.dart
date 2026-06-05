import 'package:flutter/material.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/widgets/build_search_field.dart';

Widget buildAppBar(
  BuildContext context,
  TextEditingController queryController,
) {
  return SliverAppBar(
    floating: true,
    pinned: false,
    snap: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    expandedHeight: 150,
    flexibleSpace: FlexibleSpaceBar(
      background: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(
              'Global News',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            buildSearchField(queryController, context),
          ],
        ),
      ),
    ),
  );
}
