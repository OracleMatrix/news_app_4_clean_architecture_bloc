import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app_4_clean_architecture_bloc/core/router/app_routes.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/widgets/build_search_field.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/widgets/category_chip_items.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/widgets/set_filter.dart';

Widget buildAppBar(
  BuildContext context,
  TextEditingController queryController,
) {
  return SliverAppBar(
    floating: true,
    pinned: false,
    snap: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    expandedHeight: 260,
    flexibleSpace: FlexibleSpaceBar(
      background: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Global News',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                IconButton(
                  tooltip: 'Bookmarked News',
                  onPressed: () => context.push(AppRoutes.bookmarkedNews),
                  icon: Icon(
                    Icons.bookmark_border_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            buildSearchField(queryController, context),
            const SizedBox(height: 12),
            const CategoryChipGroup(),
            const SizedBox(height: 8),
            SetFilterOnNews(queryController: queryController),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}
