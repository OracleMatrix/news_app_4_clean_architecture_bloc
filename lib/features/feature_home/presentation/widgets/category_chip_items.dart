import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/bloc/home_bloc.dart';

class CategoryChipGroup extends StatelessWidget {
  const CategoryChipGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          CategoryItems(item: Category.technology),
          CategoryItems(item: Category.general),
          CategoryItems(item: Category.business),
          CategoryItems(item: Category.entertainment),
          CategoryItems(item: Category.health),
          CategoryItems(item: Category.science),
          CategoryItems(item: Category.sports),
          CategoryItems(item: Category.world),
        ],
      ),
    );
  }
}

class CategoryItems extends StatelessWidget {
  final Category item;
  const CategoryItems({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(item.name),
        selected: context.select<HomeBloc, bool>(
          (bloc) => bloc.state.selectedCategory == item,
        ),
        backgroundColor: Theme.of(context).chipTheme.backgroundColor,
        labelStyle: TextStyle(color: Theme.of(context).chipTheme.selectedColor),
        onSelected: (value) {
          context.read<HomeBloc>().add(
            ChangeCategoryEvent(
              category: item,
              filterNewsStatus: context.read<HomeBloc>().state.selectedFilter,
            ),
          );
        },
      ),
    );
  }
}
