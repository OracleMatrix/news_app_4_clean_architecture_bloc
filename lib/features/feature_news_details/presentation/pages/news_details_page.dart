import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:news_app_4_clean_architecture_bloc/core/router/app_routes.dart';
import 'package:news_app_4_clean_architecture_bloc/di.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/entity/bookmarked_news_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/presentation/bloc/book_marked_news_bloc.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/domain/entities/news_detail_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/presentation/bloc/news_details_bloc.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/presentation/pages/fullscreen_image_viewer.dart';

class NewsDetailsPage extends StatelessWidget {
  final ArticleEntity article;

  const NewsDetailsPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final newsDetail = NewsDetailEntity.fromArticleEntity(article);

    return BlocProvider<NewsDetailsBloc>(
      create: (context) => di<NewsDetailsBloc>(),
      child: BlocListener<NewsDetailsBloc, NewsDetailsState>(
        listener: (context, state) {
          if (state.shareStatus == ShareStatus.loading) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Text("Preparing link to share..."),
                    ],
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
          } else if (state.shareStatus == ShareStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text("Shared successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
          } else if (state.shareStatus == ShareStatus.error) {
            final errorMsg = state.errorMessage ?? '';
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Failed to share: $errorMsg"),
                  backgroundColor: Colors.redAccent,
                ),
              );
          }
        },
        child: Scaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context, newsDetail),
              _buildContentList(context, newsDetail),
            ],
          ),
          bottomNavigationBar: _buildBottomActions(context, newsDetail),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, NewsDetailEntity news) {
    final hasImage = news.urlToImage.isNotEmpty;

    return SliverAppBar(
      expandedHeight: 340,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(100),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: GestureDetector(
          onTap: () {
            if (hasImage) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      FullscreenImageViewer(imageUrl: news.urlToImage),
                ),
              );
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasImage)
                Hero(
                  tag: news.urlToImage,
                  child: CachedNetworkImage(
                    imageUrl: news.urlToImage,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Theme.of(context).colorScheme.primary,
                          size: 40,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                )
              else
                Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.image, size: 80),
                ),
              // Shadow gradients
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black87,
                      ],
                      stops: [0.0, 0.2, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
              // Floating instructions overlay for tapped image
              if (hasImage)
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.zoom_in, size: 14, color: Colors.white70),
                        SizedBox(width: 4),
                        Text(
                          "Tap to zoom",
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentList(BuildContext context, NewsDetailEntity news) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Source Name and Date Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        news.sourceName.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.calendar_month,
                      size: 16,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(news.publishedAt),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // Article Title
                Text(
                  news.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 16),
                // Author row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.secondaryContainer,
                      child: Icon(
                        Icons.person,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news.author,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Author",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                // News Description
                if (news.description.isNotEmpty) ...[
                  Text(
                    news.description,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                // News Content
                Text(
                  _cleanContent(news.content),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.7,
                    letterSpacing: 0.2,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildBottomActions(BuildContext context, NewsDetailEntity news) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Share Button
          Builder(
            builder: (blocContext) {
              return Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: Theme.of(blocContext).colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(
                      blocContext,
                    ).colorScheme.outline.withAlpha(40),
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.share_outlined,
                    color: Theme.of(blocContext).colorScheme.primary,
                  ),
                  tooltip: 'Share News',
                  onPressed: () {
                    BlocProvider.of<NewsDetailsBloc>(
                      blocContext,
                    ).add(ShareArticleEvent(url: news.url, title: news.title));
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          // View in Web View button
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (news.url.isNotEmpty) {
                    context.push(
                      AppRoutes.webView,
                      extra: {'url': news.url, 'title': news.sourceName},
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "No URL link available for this article.",
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.chrome_reader_mode_outlined),
                label: const Text(
                  "Read Full Article",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          BookmarkIconButton(article: article),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final DateTime date = DateTime.parse(dateStr);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _cleanContent(String content) {
    // Standard NewsAPI truncated message suffix is typically "[+123 chars]"
    final index = content.indexOf(' [+');
    if (index != -1) {
      return content.substring(0, index);
    }
    return content;
  }
}

class BookmarkIconButton extends StatelessWidget {
  const BookmarkIconButton({super.key, required this.article});

  final ArticleEntity article;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di<BookMarkedNewsBloc>()
            ..add(CheckIsNewsBookmarkedEvent(url: article.url ?? '')),
      child: BlocBuilder<BookMarkedNewsBloc, BookMarkedNewsState>(
        builder: (context, state) {
          if (state.submitRequest == BookMarkNewsStatus.loading) {
            return const CircularProgressIndicator();
          }
          return Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withAlpha(40),
              ),
            ),
            child: IconButton(
              tooltip: (state.isBookmarked ?? false)
                  ? 'Remove from bookmarks'
                  : 'Add to bookmarks',
              onPressed: () {
                if (state.isBookmarked ?? false) {
                  context.read<BookMarkedNewsBloc>().add(
                    RemoveBookmarkedNewsEvent(url: article.url ?? ''),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Article removed from bookmarks."),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  context.read<BookMarkedNewsBloc>().add(
                    AddBookmarkedNewsEvent(
                      bookMarkedNewsEntity:
                          BookMarkedNewsEntity.fromArticleEntity(article),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Article added to bookmarks."),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              icon: Icon(
                (state.isBookmarked ?? false)
                    ? Icons.bookmark_added
                    : Icons.bookmark_add_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}
