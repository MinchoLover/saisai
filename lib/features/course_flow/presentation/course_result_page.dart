import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/course_plan.dart';

class CourseResultPage extends StatelessWidget {
  const CourseResultPage({super.key, required this.plan});
  final CoursePlan plan;

  @override
  Widget build(BuildContext context) {
    final place = plan.places.first;
    return Scaffold(
      appBar: AppBar(
        title: const Text('추천 코스'),
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_rounded)),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.bookmark_border_rounded))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [AppTheme.primaryDark, AppTheme.primary]),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Container(
                            width: 58,
                            height: 58,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .16),
                                shape: BoxShape.circle),
                            child: const Icon(Icons.check_rounded,
                                color: Colors.white, size: 30)),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('시간 안에 딱 맞는 코스예요',
                                  style: TextStyle(color: Colors.white70)),
                              const SizedBox(height: 5),
                              Text(
                                  '총 ${plan.totalRequiredMinutes}분 · ${plan.remainingMinutes}분 여유',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('이동 순서',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 14),
                  _TimelineStop(
                    badge: '출발',
                    title: plan.condition.startName,
                    subtitle: '${plan.condition.travelMode}로 이동 시작',
                    icon: Icons.trip_origin_rounded,
                    isFirst: true,
                  ),
                  _TimelineStop(
                    badge: '사이사이',
                    title: place.name,
                    subtitle:
                        '이동 ${place.detourMinutes}분 · 체류 ${place.stayMinutes}분',
                    icon: Icons.place_rounded,
                    emoji: place.imageEmoji,
                  ),
                  _TimelineStop(
                    badge: '도착',
                    title: plan.condition.destinationName,
                    subtitle: '${plan.remainingMinutes}분 여유 있게 도착',
                    icon: Icons.flag_rounded,
                    isLast: true,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.line)),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb_outline_rounded,
                            color: AppTheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Text(
                                '예상보다 시간이 부족해지면 ${place.name}의 체류 시간을 줄여 자동으로 맞출 수 있어요.',
                                style: const TextStyle(
                                    color: AppTheme.muted, height: 1.45))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: FilledButton.icon(
                onPressed: () => context.push('/active', extra: plan),
                icon: const Icon(Icons.navigation_rounded),
                label: const Text('이 코스로 출발하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineStop extends StatelessWidget {
  const _TimelineStop(
      {required this.badge,
      required this.title,
      required this.subtitle,
      required this.icon,
      this.emoji,
      this.isFirst = false,
      this.isLast = false});
  final String badge;
  final String title;
  final String subtitle;
  final IconData icon;
  final String? emoji;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 42,
              child: Column(
                children: [
                  if (!isFirst)
                    Expanded(child: Container(width: 2, color: AppTheme.line)),
                  Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                          color: AppTheme.mint, shape: BoxShape.circle),
                      child: Icon(icon, size: 18, color: AppTheme.primary)),
                  if (!isLast)
                    Expanded(child: Container(width: 2, color: AppTheme.line)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 7),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.line)),
                child: Row(
                  children: [
                    if (emoji != null) ...[
                      Text(emoji!, style: const TextStyle(fontSize: 30)),
                      const SizedBox(width: 12)
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(badge,
                              style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text(title,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Text(subtitle,
                              style: const TextStyle(
                                  color: AppTheme.muted, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
