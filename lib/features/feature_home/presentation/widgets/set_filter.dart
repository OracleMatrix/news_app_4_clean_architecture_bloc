import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/bloc/home_bloc.dart';

class SetFilterOnNews extends StatelessWidget {
  final TextEditingController queryController;
  const SetFilterOnNews({super.key, required this.queryController});

  @override
  Widget build(BuildContext context) {
    final selectedFilter = context.select<HomeBloc, FilterNewsStatus>(
      (bloc) => bloc.state.selectedFilter,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.sort_rounded,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Sort Articles by',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          InkWell(
            onTap: () => _showFilterBottomSheet(context, selectedFilter),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(102),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant.withAlpha(128),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIconForStatus(selectedFilter),
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _getLabelForStatus(selectedFilter),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForStatus(FilterNewsStatus status) {
    switch (status) {
      case FilterNewsStatus.popularity:
        return Icons.local_fire_department_rounded;
      case FilterNewsStatus.publishedAt:
        return Icons.access_time_filled_rounded;
      case FilterNewsStatus.relevancy:
        return Icons.analytics_rounded;
    }
  }

  String _getLabelForStatus(FilterNewsStatus status) {
    switch (status) {
      case FilterNewsStatus.popularity:
        return 'Popular';
      case FilterNewsStatus.publishedAt:
        return 'Latest';
      case FilterNewsStatus.relevancy:
        return 'Relevant';
    }
  }

  String _getDescriptionForStatus(FilterNewsStatus status) {
    switch (status) {
      case FilterNewsStatus.popularity:
        return 'Popular articles from important sources and key publishers.';
      case FilterNewsStatus.publishedAt:
        return 'Latest articles published, sorted by date and time.';
      case FilterNewsStatus.relevancy:
        return 'Articles most closely matching your current search terms.';
    }
  }

  void _showFilterBottomSheet(BuildContext context, FilterNewsStatus selectedFilter) {
    final homeBloc = context.read<HomeBloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(102),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Sort articles by',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                ...FilterNewsStatus.values.map((status) {
                  final isSelected = status == selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(sheetContext);
                        final searchStr = queryController.text.isNotEmpty
                            ? queryController.text
                            : homeBloc.state.selectedCategory.name;
                        homeBloc.add(
                          FilterNewsEvent(filterQuery: status, searchQuery: searchStr),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primaryContainer.withAlpha(38)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary.withAlpha(76)
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary.withAlpha(38)
                                    : Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(26),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getIconForStatus(status),
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getLabelForStatus(status),
                                    style: TextStyle(
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 16,
                                      color: isSelected
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _getDescriptionForStatus(status),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
