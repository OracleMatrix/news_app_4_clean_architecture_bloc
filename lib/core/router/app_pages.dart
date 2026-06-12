import 'package:go_router/go_router.dart';
import 'package:news_app_4_clean_architecture_bloc/core/router/app_routes.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/presentation/pages/bookmarked_news_page.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/pages/home_page.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/presentation/pages/news_details_page.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/presentation/pages/news_web_view_page.dart';

final router = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.newsDetails,
      builder: (context, state) {
        final article = state.extra as ArticleEntity;
        return NewsDetailsPage(article: article);
      },
    ),
    GoRoute(
      path: AppRoutes.webView,
      builder: (context, state) {
        final extra = state.extra as Map<String, String>;
        final url = extra['url'] ?? '';
        final title = extra['title'] ?? '';
        return NewsWebViewPage(url: url, title: title);
      },
    ),
    GoRoute(
      path: AppRoutes.bookmarkedNews,
      builder: (context, state) => BookmarkedNewsPage(),
    ),
  ],
);
