import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/place_image.dart';
import '../../../models/candidate_place.dart';
import '../../../models/search_condition.dart';
import '../../../services/course_planner.dart';

class PlaceDetailArgs {
  const PlaceDetailArgs(this.condition, this.place);
  final SearchCondition condition;
  final CandidatePlace place;
}

class PlaceDetailPage extends StatelessWidget {
  PlaceDetailPage({super.key, required this.args});
  final PlaceDetailArgs args;
  final _planner = CoursePlanner();

  @override
  Widget build(BuildContext context) {
    final place = args.place;
    final afterVisit = args.condition.availableMinutes - place.requiredMinutes;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 278,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded)),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_border_rounded)),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PlaceImage(place: place, emojiSize: 104),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Color(0x66000000)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                      right: -24,
                      top: 58,
                      child: Icon(Icons.circle,
                          size: 170,
                          color: Colors.white.withValues(alpha: .3))),
                  Positioned(
                    left: 20,
                    bottom: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 7),
                      decoration: BoxDecoration(
                          color: AppTheme.ink.withValues(alpha: .82),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(place.category,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(place.name,
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -.8)),
                      ),
                      if (place.distanceMeters > 0)
                        Text(_distanceLabel(place.distanceMeters),
                            style: const TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(place.description,
                      style: const TextStyle(
                          color: AppTheme.muted, fontSize: 16, height: 1.55)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: AppTheme.mint,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.auto_awesome_rounded,
                                color: AppTheme.primary, size: 20),
                            SizedBox(width: 7),
                            Text('이 코스에 잘 맞아요',
                                style: TextStyle(fontWeight: FontWeight.w900)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                                child: _TimeStat(
                                    label: '추가 이동',
                                    value: '${place.detourMinutes}분')),
                            Expanded(
                                child: _TimeStat(
                                    label: '추천 체류',
                                    value: '${place.stayMinutes}분')),
                            Expanded(
                                child: _TimeStat(
                                    label: '도착 여유',
                                    value: '$afterVisit분',
                                    highlight: true)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text('장소 정보',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 14),
                  _InfoRow(
                      icon: Icons.location_on_outlined,
                      title: '위치',
                      value:
                          place.address.isEmpty ? '위치 정보 없음' : place.address),
                  if (place.latitude != 0 && place.longitude != 0)
                    _InfoRow(
                      icon: Icons.map_outlined,
                      title: '좌표',
                      value:
                          '${place.latitude.toStringAsFixed(5)}, ${place.longitude.toStringAsFixed(5)}',
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: FilledButton.icon(
            onPressed: () => context.push('/result',
                extra: _planner.createPlan(args.condition, place)),
            icon: const Icon(Icons.add_road_rounded),
            label: const Text('이 장소를 코스에 담기'),
          ),
        ),
      ),
    );
  }

  String _distanceLabel(int meters) => meters < 1000
      ? '${meters}m 거리'
      : '${(meters / 1000).toStringAsFixed(1)}km 거리';
}

class _TimeStat extends StatelessWidget {
  const _TimeStat(
      {required this.label, required this.value, this.highlight = false});
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(label,
              style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
          const SizedBox(height: 5),
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: highlight ? AppTheme.primary : AppTheme.ink)),
        ],
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(
      {required this.icon, required this.title, required this.value});
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.line)),
                child: Icon(icon, color: AppTheme.primary, size: 20)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style:
                          const TextStyle(fontSize: 13, color: AppTheme.muted)),
                  Text(value,
                      style: const TextStyle(fontWeight: FontWeight.w700))
                ])),
          ],
        ),
      );
}
