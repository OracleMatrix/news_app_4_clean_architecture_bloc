import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/bloc/home_bloc.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/widgets/news_card.dart';

Widget buildNewsContent(TextEditingController queryController) {
  return BlocBuilder<HomeBloc, HomeState>(
    builder: (context, state) {
      if (state.getNewsStatus is LoadingNewsStatus) {
        return SliverFillRemaining(
          child: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Theme.of(context).colorScheme.primary,
              size: 50,
            ),
          ),
        );
      }

      if (state.getNewsStatus is ErrorOnGettingNewsStatus) {
        final errorStatus = state.getNewsStatus as ErrorOnGettingNewsStatus;
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  errorStatus.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<HomeBloc>(context).add(
                      LoadNewsEvent(
                        queryController.text.isEmpty
                            ? 'technology'
                            : queryController.text,
                      ),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      if (state.getNewsStatus is GetNewsCompletedStatus) {
        final getNewsCompletedStatus =
            state.getNewsStatus as GetNewsCompletedStatus;
        final articles = getNewsCompletedStatus.getNewsEntity.articles ?? [];

        if (articles.isEmpty) {
          return const SliverFillRemaining(
            child: Center(child: Text('No news found.')),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return NewsCard(article: articles[index]);
            }, childCount: articles.length),
          ),
        );
      }

      return const SliverToBoxAdapter(child: SizedBox.shrink());
    },
  );
}
