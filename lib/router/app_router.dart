import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:detection_disease_leaf_melon_fruits/screen/home/home_page.dart';
import 'package:detection_disease_leaf_melon_fruits/screen/result/result_page.dart';
import 'package:detection_disease_leaf_melon_fruits/data/prediction_result.dart';

import '../screen/home/home_content_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return HomePage(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeContentPage(),
        ),
        // GoRoute(
        //   path: '/history',
        //   builder: (context, state) => const HistoryPage(),
        // ),
      ],
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final result = extra['result'] as PredictionResult;
        final imageFile = extra['imageFile'] as File;
        return ResultPage(result: result, imageFile: imageFile);
      },
    ),
  ],
);
