import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/saisai_bottom_nav.dart';
import '../../../core/widgets/tour_map.dart';
import '../../../models/search_condition.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  static const _collapsedSheetSize = 0.15;
  static const _expandedSheetSize = 0.38;

  final _start = TextEditingController(text: '서울역');
  final _destination = TextEditingController(text: '광화문');
  final _sheetController = DraggableScrollableController();

  double _sheetSize = _expandedSheetSize;

  bool get _isSheetCollapsed => _sheetSize < 0.3;

  bool get _canContinue =>
      _start.text.trim().isNotEmpty && _destination.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _start.addListener(_refresh);
    _destination.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _start
      ..removeListener(_refresh)
      ..dispose();
    _destination
      ..removeListener(_refresh)
      ..dispose();
    _sheetController.dispose();
    super.dispose();
  }

  Future<void> _toggleSheet() async {
    if (!_sheetController.isAttached) return;
    final target = _isSheetCollapsed ? _expandedSheetSize : _collapsedSheetSize;
    if (target == _collapsedSheetSize) {
      FocusScope.of(context).unfocus();
    }
    await _sheetController.animateTo(
      target,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _expandSheet() async {
    if (!_sheetController.isAttached || !_isSheetCollapsed) return;
    await _sheetController.animateTo(
      _expandedSheetSize,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _next() {
    FocusScope.of(context).unfocus();
    context.push(
      '/preferences',
      extra: SearchCondition(
        startName: _start.text.trim(),
        destinationName: _destination.text.trim(),
        availableMinutes: 60,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Row(
            children: [
              Icon(Icons.route_rounded, color: AppTheme.primary),
              SizedBox(width: 8),
              Text('사이사이'),
            ],
          ),
          actions: [
            IconButton(
              tooltip: '도움말',
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('출발지와 목적지 사이의 짧은 여행을 찾아드려요.')),
              ),
              icon: const Icon(Icons.help_outline_rounded),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Stack(
          children: [
            TourMap(
              startLabel: _start.text.isEmpty ? '출발지' : _start.text,
              destinationLabel:
                  _destination.text.isEmpty ? '목적지' : _destination.text,
            ),
            NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                if ((_sheetSize - notification.extent).abs() > 0.005) {
                  setState(() => _sheetSize = notification.extent);
                }
                return false;
              },
              child: DraggableScrollableSheet(
                controller: _sheetController,
                initialChildSize: _expandedSheetSize,
                minChildSize: _collapsedSheetSize,
                maxChildSize: _expandedSheetSize,
                snap: true,
                snapAnimationDuration: const Duration(milliseconds: 220),
                builder: (context, scrollController) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1F000000),
                        blurRadius: 24,
                        offset: Offset(0, -6),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: ListView(
                      controller: scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      children: [
                        _SheetHandle(
                          isCollapsed: _isSheetCollapsed,
                          onTap: _toggleSheet,
                        ),
                        const SizedBox(height: 10),
                        if (_isSheetCollapsed)
                          _CollapsedLocationSummary(
                            start: _start.text.trim(),
                            destination: _destination.text.trim(),
                            onTap: _toggleSheet,
                          )
                        else ...[
                          _LocationField(
                            controller: _start,
                            label: '출발지',
                            icon: Icons.trip_origin_rounded,
                            onTap: _expandSheet,
                            onLocate: () => _start.text = '현재 위치',
                          ),
                          const SizedBox(height: 10),
                          _LocationField(
                            controller: _destination,
                            label: '목적지',
                            icon: Icons.location_on_outlined,
                            onTap: _expandSheet,
                            onLocate: () => _destination.text = '광화문',
                          ),
                          const SizedBox(height: 14),
                          FilledButton(
                            onPressed: _canContinue ? _next : null,
                            child: const Text('다음'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const SaisaiBottomNav(index: 0),
      );
}

class _LocationField extends StatelessWidget {
  const _LocationField(
      {required this.controller,
      required this.label,
      required this.icon,
      required this.onTap,
      required this.onLocate});
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onLocate;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        onTap: onTap,
        textInputAction:
            label == '출발지' ? TextInputAction.next : TextInputAction.done,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon,
              color: label == '출발지' ? AppTheme.ink : AppTheme.primary),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: onLocate,
                  icon: const Icon(Icons.my_location_rounded),
                  tooltip: '현재 위치'),
              const Icon(Icons.map_outlined),
              const SizedBox(width: 14),
            ],
          ),
        ),
      );
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle({required this.isCollapsed, required this.onTap});

  final bool isCollapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: isCollapsed ? '출발지 입력창 펼치기' : '출발지 입력창 접기',
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppTheme.line,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      );
}

class _CollapsedLocationSummary extends StatelessWidget {
  const _CollapsedLocationSummary({
    required this.start,
    required this.destination,
    required this.onTap,
  });

  final String start;
  final String destination;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppTheme.mint,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.route_rounded, color: AppTheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${start.isEmpty ? '출발지' : start}  →  '
                    '${destination.isEmpty ? '목적지' : destination}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_up_rounded),
              ],
            ),
          ),
        ),
      );
}
