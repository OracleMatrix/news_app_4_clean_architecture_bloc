import 'package:go_router/go_router.dart';
import 'package:news_app_4_clean_architecture_bloc/core/router/app_routes.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/pages/home_page.dart';

final router = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    // GoRoute(
    //   path: AppRoutes.newsDetails,
    //   // builder: (context, state) => const NewsDetails(),
    // ),
  ],
);
