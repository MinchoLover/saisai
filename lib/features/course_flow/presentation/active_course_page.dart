import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/course_plan.dart';

class ActiveCoursePage extends StatefulWidget {
  const ActiveCoursePage({super.key, required this.plan});
  final CoursePlan plan;

  @override
  State<ActiveCoursePage> createState() => _ActiveCoursePageState();
}

class _ActiveCoursePageState extends State<ActiveCoursePage> {
  var _completed = false;

  @override
  Widget build(BuildContext context) {
    final place = widget.plan.places.first;
    return Scaffold(
      appBar: AppBar(
        title: const Text('코스 진행 중'),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_horiz_rounded))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: AppTheme.mint,
                        borderRadius: BorderRadius.circular(22)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('목적지까지',
                            style: TextStyle(color: AppTheme.muted)),
                        const SizedBox(height: 6),
                        Text(
                            '${widget.plan.totalRequiredMinutes + widget.plan.remainingMinutes}분 남았어요',
                            style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.primaryDark)),
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                              value: _completed ? .68 : .24,
                              minHeight: 9,
                              backgroundColor: Colors.white,
                              color: AppTheme.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  _ProgressCard(
                      label: '출발',
                      title: widget.plan.condition.startName,
                      subtitle: '출발 완료',
                      state: _completed ? 2 : 1,
                      emoji: '🚩'),
                  _ProgressCard(
                      label: '사이사이',
                      title: place.name,
                      subtitle: _completed
                          ? '${place.stayMinutes}분 머무르기'
                          : '${place.detourMinutes}분 뒤 도착',
                      state: _completed ? 1 : 0,
                      emoji: place.imageEmoji),
                  _ProgressCard(
                      label: '도착',
                      title: widget.plan.condition.destinationName,
                      subtitle: '${widget.plan.remainingMinutes}분 여유',
                      state: 0,
                      emoji: '🏁'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: FilledButton(
                onPressed: () {
                  if (_completed) {
                    context.go('/history');
                  } else {
                    setState(() => _completed = true);
                  }
                },
                child:
                    Text(_completed ? '코스 완료하고 기록하기' : '${place.name} 도착했어요'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard(
      {required this.label,
      required this.title,
      required this.subtitle,
      required this.state,
      required this.emoji});
  final String label;
  final String title;
  final String subtitle;
  final int state;
  final String emoji;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: state == 1 ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(19),
          border:
              Border.all(color: state == 1 ? AppTheme.primary : AppTheme.line),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 30)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 12,
                          color: state == 1 ? Colors.white70 : AppTheme.muted)),
                  const SizedBox(height: 3),
                  Text(title,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: state == 1 ? Colors.white : AppTheme.ink)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: TextStyle(
                          color: state == 1 ? Colors.white70 : AppTheme.muted)),
                ],
              ),
            ),
            if (state == 2)
              const Icon(Icons.check_circle_rounded, color: AppTheme.primary)
            else if (state == 1)
              const Icon(Icons.navigation_rounded, color: Colors.white),
          ],
        ),
      );
}
