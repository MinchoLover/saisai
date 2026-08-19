import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../features/course_flow/presentation/active_course_page.dart';
import '../features/course_flow/presentation/candidate_page.dart';
import '../features/course_flow/presentation/course_result_page.dart';
import '../features/course_flow/presentation/place_detail_page.dart';
import '../features/placeholders/presentation/history_page.dart';
import '../features/placeholders/presentation/my_page.dart';
import '../features/search_flow/presentation/location_page.dart';
import '../features/search_flow/presentation/preferences_page.dart';
import '../features/search_flow/presentation/welcome_page.dart';
import '../models/course_plan.dart';
import '../models/search_condition.dart';

class SaisaiApp extends StatelessWidget {
  const SaisaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '사이사이',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const LocationPage()),
    GoRoute(path: '/welcome', builder: (_, __) => const WelcomePage()),
    GoRoute(path: '/locations', builder: (_, __) => const LocationPage()),
    GoRoute(
      path: '/preferences',
      builder: (_, state) =>
          PreferencesPage(condition: state.extra! as SearchCondition),
    ),
    GoRoute(
      path: '/candidates',
      builder: (_, state) =>
          CandidatePage(condition: state.extra! as SearchCondition),
    ),
    GoRoute(
      path: '/place',
      builder: (_, state) =>
          PlaceDetailPage(args: state.extra! as PlaceDetailArgs),
    ),
    GoRoute(
      path: '/result',
      builder: (_, state) => CourseResultPage(plan: state.extra! as CoursePlan),
    ),
    GoRoute(
      path: '/active',
      builder: (_, state) => ActiveCoursePage(plan: state.extra! as CoursePlan),
    ),
    GoRoute(
      path: '/my',
      builder: (_, __) => const MyPage(),
    ),
    GoRoute(
      path: '/history',
      builder: (_, __) => const HistoryPage(),
    ),
  ],
);
