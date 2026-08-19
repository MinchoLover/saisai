import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/saisai_bottom_nav.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('경로 기록')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: const [
            _HistoryCard(
                date: '오늘',
                route: '서울역 → 서울로7017 → 광화문',
                time: '총 45분',
                emoji: '🌿',
                color: Color(0xFFDDEFE6)),
            SizedBox(height: 12),
            _HistoryCard(
                date: '8월 12일',
                route: '시청역 → 덕수궁 → 종각역',
                time: '총 58분',
                emoji: '🏯',
                color: Color(0xFFF2E7CF)),
            SizedBox(height: 12),
            _HistoryCard(
                date: '8월 3일',
                route: '을지로입구 → 남대문시장 → 서울역',
                time: '총 50분',
                emoji: '🥟',
                color: Color(0xFFF3DDDA)),
          ],
        ),
        bottomNavigationBar: const SaisaiBottomNav(index: 1),
      );
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard(
      {required this.date,
      required this.route,
      required this.time,
      required this.emoji,
      required this.color});
  final String date;
  final String route;
  final String time;
  final String emoji;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.line)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(date,
                  style: const TextStyle(
                      color: AppTheme.primary, fontWeight: FontWeight.w800)),
              const Spacer(),
              const Icon(Icons.more_horiz_rounded, color: AppTheme.muted)
            ]),
            const SizedBox(height: 13),
            Row(
              children: [
                Container(
                    width: 62,
                    height: 62,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(17)),
                    child: Text(emoji, style: const TextStyle(fontSize: 32))),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(route,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              height: 1.4)),
                      const SizedBox(height: 7),
                      Row(children: [
                        const Icon(Icons.schedule_rounded,
                            size: 16, color: AppTheme.muted),
                        const SizedBox(width: 5),
                        Text(time,
                            style: const TextStyle(color: AppTheme.muted))
                      ])
                    ])),
              ],
            ),
          ],
        ),
      );
}
