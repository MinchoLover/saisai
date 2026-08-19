import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_scaffold.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title, required this.icon});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) => AppScaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 56),
          const SizedBox(height: 16),
          Text('$title 기능은 준비 중입니다.'),
          const SizedBox(height: 12),
          OutlinedButton(
              onPressed: () => context.go('/'), child: const Text('홈으로 돌아가기')),
        ])),
      );
}
