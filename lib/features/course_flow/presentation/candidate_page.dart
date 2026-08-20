import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/tour_map.dart';
import '../../../data/tour_api_repository.dart';
import '../../../models/candidate_place.dart';
import '../../../models/search_condition.dart';
import '../../../services/course_planner.dart';
import 'place_detail_page.dart';

class CandidatePage extends StatefulWidget {
  const CandidatePage({super.key, required this.condition});
  final SearchCondition condition;

  @override
  State<CandidatePage> createState() => _CandidatePageState();
}

class _CandidatePageState extends State<CandidatePage> {
  final _repository = TourApiRepository();
  final _planner = CoursePlanner();
  late Future<List<CandidatePlace>> _candidates;

  SearchCondition get condition => widget.condition;

  @override
  void initState() {
    super.initState();
    _loadCandidates();
  }

  void _loadCandidates() {
    _candidates = _repository
        .candidatesFor(condition)
        .then((places) => _planner.feasibleCandidates(condition, places));
  }

  void _retry() => setState(_loadCandidates);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CandidatePlace>>(
      future: _candidates,
      builder: (context, snapshot) {
        final candidates = snapshot.data ?? const <CandidatePlace>[];
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: TourMap(
                  startLabel: condition.startName,
                  destinationLabel: condition.destinationName,
                  showCandidates: true,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _MapButton(
                              icon: Icons.arrow_back_rounded,
                              onTap: () => context.pop()),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 13),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0x1A000000),
                                      blurRadius: 16,
                                      offset: Offset(0, 4))
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.alt_route_rounded,
                                      color: AppTheme.primary, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                        '${condition.startName} → ${condition.destinationName}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800)),
                                  ),
                                  Text('${condition.availableMinutes}분',
                                      style: const TextStyle(
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _ConditionChip(
                                  icon: Icons.directions_walk_rounded,
                                  label: condition.travelMode),
                              ...condition.categories.map((category) =>
                                  _ConditionChip(label: category)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: .44,
                minChildSize: .32,
                maxChildSize: .72,
                snap: true,
                builder: (context, controller) => Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.canvas,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 24,
                          offset: Offset(0, -4))
                    ],
                  ),
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? ListView(
                          controller: controller,
                          padding: const EdgeInsets.all(24),
                          children: const [
                            _SheetHandle(),
                            SizedBox(height: 54),
                            Center(child: CircularProgressIndicator()),
                            SizedBox(height: 18),
                            Text(
                              '주변 관광지를 찾고 있어요',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ],
                        )
                      : snapshot.hasError
                          ? ListView(
                              controller: controller,
                              padding: const EdgeInsets.all(24),
                              children: [
                                const _SheetHandle(),
                                const SizedBox(height: 36),
                                const Icon(Icons.cloud_off_rounded,
                                    size: 54, color: AppTheme.muted),
                                const SizedBox(height: 14),
                                const Text(
                                  '관광정보를 불러오지 못했어요',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: AppTheme.muted),
                                ),
                                const SizedBox(height: 18),
                                OutlinedButton.icon(
                                  onPressed: _retry,
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('다시 시도'),
                                ),
                              ],
                            )
                          : candidates.isEmpty
                              ? ListView(
                                  controller: controller,
                                  padding: const EdgeInsets.all(24),
                                  children: const [
                                    _SheetHandle(),
                                    SizedBox(height: 42),
                                    Icon(Icons.search_off_rounded,
                                        size: 54, color: AppTheme.muted),
                                    SizedBox(height: 14),
                                    Text('조건에 맞는 장소가 아직 없어요',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800)),
                                    SizedBox(height: 8),
                                    Text('시간을 늘리거나 다른 카테고리를 선택해 보세요.',
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(color: AppTheme.muted)),
                                  ],
                                )
                              : ListView.builder(
                                  controller: controller,
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 10, 18, 24),
                                  itemCount: candidates.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 14),
                                        child: Column(
                                          children: [
                                            const _SheetHandle(),
                                            const SizedBox(height: 14),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          '${candidates.length}개의 사이사이 발견',
                                                          style: const TextStyle(
                                                              fontSize: 21,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900)),
                                                      const SizedBox(height: 4),
                                                      const Text(
                                                          '시간 안에 들를 수 있는 순서예요',
                                                          style: TextStyle(
                                                              color: AppTheme
                                                                  .muted)),
                                                    ],
                                                  ),
                                                ),
                                                const Icon(Icons.tune_rounded,
                                                    color: AppTheme.primary),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    final place = candidates[index - 1];
                                    return _CandidateCard(
                                      place: place,
                                      rank: index,
                                      onTap: () => context.push('/place',
                                          extra: PlaceDetailArgs(
                                              condition, place)),
                                    );
                                  },
                                ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        child: IconButton(onPressed: onTap, icon: Icon(icon)),
      );
}

class _ConditionChip extends StatelessWidget {
  const _ConditionChip({required this.label, this.icon});
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(right: 7),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Color(0x14000000), blurRadius: 8)
            ]),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppTheme.primary),
              const SizedBox(width: 5)
            ],
            Text(label,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
      );
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(
                color: const Color(0xFFC5CCC9),
                borderRadius: BorderRadius.circular(10))),
      );
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard(
      {required this.place, required this.rank, required this.onTap});
  final CandidatePlace place;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 11),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppTheme.mint,
                      borderRadius: BorderRadius.circular(16)),
                  child: Text(place.imageEmoji,
                      style: const TextStyle(fontSize: 29)),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(7)),
                            child: Text('$rank',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800)),
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                              child: Text(place.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('${place.category} · ★ ${place.rating}',
                          style: const TextStyle(
                              color: AppTheme.muted, fontSize: 13)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.schedule_rounded,
                              size: 15, color: AppTheme.primary),
                          const SizedBox(width: 4),
                          Text(
                              '이동 ${place.detourMinutes}분 · 체류 ${place.stayMinutes}분',
                              style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppTheme.muted),
              ],
            ),
          ),
        ),
      );
}
