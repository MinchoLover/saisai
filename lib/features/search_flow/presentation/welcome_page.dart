import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) => AppScaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                height: 104,
                width: 104,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Center(
                    child: Text('🧭', style: TextStyle(fontSize: 52))),
              ),
              const SizedBox(height: 28),
              Text('목적지까지 가는 길,\n빈 시간을 여행으로 채워요.',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.ink,
                      )),
              const SizedBox(height: 14),
              Text('사이사이가 남은 시간과 취향에 맞는\n잠깐의 여행을 추천해 드릴게요.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(height: 1.5)),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go('/locations'),
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56)),
                child: const Text('사이사이 여행 시작하기'),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => context.go('/history'),
                icon: const Icon(Icons.route_outlined),
                label: const Text('경로 기록 (준비 중)'),
              ),
            ],
          ),
        ),
      );
}
