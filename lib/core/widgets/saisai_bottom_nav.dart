import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

class SaisaiBottomNav extends StatelessWidget {
  const SaisaiBottomNav({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) => NavigationBar(
        height: 68,
        selectedIndex: index,
        indicatorColor: AppTheme.mint,
        backgroundColor: Colors.white,
        onDestinationSelected: (value) {
          if (value == 0) context.go('/');
          if (value == 1) context.go('/history');
          if (value == 2) context.go('/my');
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: '여행'),
          NavigationDestination(
              icon: Icon(Icons.route_outlined),
              selectedIcon: Icon(Icons.route),
              label: '경로 기록'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: '마이'),
        ],
      );
}
