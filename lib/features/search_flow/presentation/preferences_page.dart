import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/search_condition.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key, required this.condition});
  final SearchCondition condition;

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  late int _minutes = widget.condition.availableMinutes;
  String _travelMode = '도보';
  final Set<String> _categories = {'산책'};
  static const _categoryOptions = ['산책', '전시', '맛집', '역사', '쇼핑', '휴식'];
  static const _modes = ['도보', '대중교통', '자동차'];

  void _changeMinutes(int delta) =>
      setState(() => _minutes = (_minutes + delta).clamp(30, 180));

  void _submit() {
    context.push(
      '/candidates',
      extra: widget.condition.copyWith(
        availableMinutes: _minutes,
        categories: _categories.toList(),
        travelMode: _travelMode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('시간과 취향'),
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_rounded)),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  children: [
                    _RouteSummary(condition: widget.condition),
                    const SizedBox(height: 24),
                    Text('목적지까지 얼마나 여유가 있나요?',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800, letterSpacing: -.5)),
                    const SizedBox(height: 8),
                    const Text('이 시간 안에서 이동과 관광을 모두 마칠 수 있게 추천해요.',
                        style: TextStyle(color: AppTheme.muted)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppTheme.mint,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: AppTheme.primary.withValues(alpha: .12)),
                      ),
                      child: Row(
                        children: [
                          _RoundControl(
                              icon: Icons.remove_rounded,
                              onTap: () => _changeMinutes(-10)),
                          Expanded(
                            child: Column(
                              children: [
                                Text('$_minutes분',
                                    style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w900,
                                        color: AppTheme.primaryDark)),
                                const Text('남은 시간',
                                    style: TextStyle(color: AppTheme.muted)),
                              ],
                            ),
                          ),
                          _RoundControl(
                              icon: Icons.add_rounded,
                              onTap: () => _changeMinutes(10)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    const _SectionTitle(
                        title: '이동수단', subtitle: '예상 이동시간 계산에 사용해요'),
                    const SizedBox(height: 12),
                    SegmentedButton<String>(
                      segments: _modes
                          .map((mode) => ButtonSegment(
                              value: mode,
                              label: Text(mode),
                              icon: Icon(_modeIcon(mode), size: 18)))
                          .toList(),
                      selected: {_travelMode},
                      showSelectedIcon: false,
                      onSelectionChanged: (value) =>
                          setState(() => _travelMode = value.first),
                    ),
                    const SizedBox(height: 28),
                    const _SectionTitle(
                        title: '관심 카테고리', subtitle: '여러 개 선택할 수 있어요'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categoryOptions
                          .map(
                            (category) => FilterChip(
                              avatar: Icon(_categoryIcon(category), size: 17),
                              label: Text(category),
                              selected: _categories.contains(category),
                              onSelected: (selected) => setState(() {
                                if (selected) {
                                  _categories.add(category);
                                } else {
                                  _categories.remove(category);
                                }
                              }),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.line)),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_awesome_rounded,
                              color: AppTheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '이동 약 ${_travelMode == '도보' ? 20 : _travelMode == '대중교통' ? 12 : 9}분 · 체류 가능 약 ${_minutes - (_travelMode == '도보' ? 20 : 12)}분',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: FilledButton(
                    onPressed: _submit, child: const Text('이 조건으로 추천받기')),
              ),
            ],
          ),
        ),
      );

  IconData _modeIcon(String mode) => switch (mode) {
        '도보' => Icons.directions_walk_rounded,
        '대중교통' => Icons.directions_bus_rounded,
        _ => Icons.directions_car_rounded,
      };

  IconData _categoryIcon(String category) => switch (category) {
        '산책' => Icons.park_outlined,
        '전시' => Icons.palette_outlined,
        '맛집' => Icons.restaurant_outlined,
        '역사' => Icons.account_balance_outlined,
        '쇼핑' => Icons.shopping_bag_outlined,
        _ => Icons.local_cafe_outlined,
      };
}

class _RouteSummary extends StatelessWidget {
  const _RouteSummary({required this.condition});
  final SearchCondition condition;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.line)),
        child: Row(
          children: [
            const Icon(Icons.alt_route_rounded, color: AppTheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                  '${condition.startName}  →  ${condition.destinationName}',
                  style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
            TextButton(onPressed: () => context.pop(), child: const Text('수정')),
          ],
        ),
      );
}

class _RoundControl extends StatelessWidget {
  const _RoundControl({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: SizedBox(width: 48, height: 48, child: Icon(icon)),
        ),
      );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(subtitle,
                  style: const TextStyle(color: AppTheme.muted, fontSize: 13))),
        ],
      );
}
