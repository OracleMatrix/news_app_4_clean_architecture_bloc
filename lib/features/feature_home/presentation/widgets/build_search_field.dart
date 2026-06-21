import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/bloc/home_bloc.dart';

Widget buildSearchField(
  TextEditingController queryController,
  BuildContext context,
) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(12),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: TextField(
      controller: queryController,
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          BlocProvider.of<HomeBloc>(context).add(
            LoadNewsEvent(
              query: value,
              filterNewsStatus: context.read<HomeBloc>().state.selectedFilter,
            ),
          );
        }
      },
      decoration: InputDecoration(
        hintText: 'Search news...',
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.primary.withAlpha(178),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    ),
  );
}
